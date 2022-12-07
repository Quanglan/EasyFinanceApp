//
//  BookViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import RealmSwift

class BookViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateBarView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var viewCalendarButton: UIButton!
    @IBOutlet weak var totalSpendLB: UILabel!
    @IBOutlet weak var totalIncomeLB: UILabel!
    @IBOutlet weak var balanceLB: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    
    let searchController = UISearchController()
    
    var totalSpend: Double = 0
    var totalIncome: Double = 0
    var balance: Double = 0
    var checkShowSearchBar: Bool = false
    var transactionData: [Transaction] = []
    var type: String = ""
    let formatter = DateFormatter()
    var queryDate: Date = Date()
    let realm = try! Realm()
    
    private let addTransactionBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(named: "Color30")
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTabBarItemIndex = 1
        view.addSubview(addTransactionBtn)

        addTransactionBtn.addTarget(self, action: #selector(addTran), for: .touchUpInside)
        navigationItem.title = "📚 Sổ giao dịch"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //searchController
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.estimatedRowHeight = 74
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "creditcard.fill"),
                                                            style: .plain, target: self,
                                                            action: #selector(showWallet))
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(showItem)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(showSearchView))
        
    
        setupView()
        getAllData()
        showTotalLB()
    }
    
    func setupView() {
        let font = UIFont.systemFont(ofSize: 17)
        
        let normalAtribute: [NSAttributedString.Key: Any] = [.font: font as Any, .foregroundColor: UIColor.gray]
        let font0 = UIFont.boldSystemFont(ofSize: 18)

        let selected0Atribute: [NSAttributedString.Key: Any] = [.font: font0 as Any, .foregroundColor: UIColor.red]
        
        segmentControl.setTitleTextAttributes(normalAtribute, for: .normal)
        segmentControl.setTitleTextAttributes(selected0Atribute, for: .selected)
        type = "spend"
        dateBarView.clipsToBounds = true
        dateBarView.layer.cornerRadius = 8
        formatter.dateFormat = "MM-yyyy"
        dateLB.text = formatter.string(from: queryDate)
        viewCalendarButton.clipsToBounds = true
        viewCalendarButton.layer.cornerRadius = 8
    }
    
    @IBAction func tapPreviousMonth(_ sender: Any) {
        let currentDay = queryDate
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = -1
        let preDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: preDay)
        queryDate = preDay
        searchTransaction()
    }
    
    @IBAction func tapNextMonth(_ sender: Any) {
        let currentDay = queryDate //tranFSCalendar.currentPage
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = 1
        let nextDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: nextDay)
        queryDate = nextDay
        searchTransaction()
    }
    
    @objc func showSearchView() {
        if checkShowSearchBar == false {
            navigationItem.searchController = searchController
            searchController.searchBar.showsCancelButton = true
            checkShowSearchBar = true
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "magnifyingglass.circle.fill")
        } else {
            navigationItem.searchController = nil
            checkShowSearchBar = false
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "magnifyingglass")
        }
    }
    
    @IBAction func tapViewCalendarButton(_ sender: Any) {
        let vc = TranCalendarViewController()
        vc.queryDate = queryDate
        vc.type = type
        vc.title = type == "spend" ? "Chi trong tháng" : type == "income" ? "Thu trong tháng" : "Chi thu trong tháng"
        vc.transactionData.removeAll()
        vc.transactionData.append(contentsOf: transactionData)
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showWallet() {
        let vc = WalletViewController()
        vc.title = "💰 Danh sách ví"
        vc.passData = {
            if vc.checkChange {
                self.tableView.reloadData()
            }
        }
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showItem() {
        let vc = ItemRptViewController()
        //vc.title = "Tổng hợp danh mục lớn"
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addTran() {
        let vc = AddTranViewController()
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTransactionBtn.frame = CGRect(x: (view.frame.size.width - 60)/2,
                                         y: view.frame.size.height - 85, width: 60, height: 60)
    }
    
    func getAllData() {
                
        transactionData.removeAll()
        if type == "all" {
            let tranList = realm.objects(Transaction.self).filter { [self] tran in
                formatter.string(from: tran.tranDate) == formatter.string(from: queryDate)
            }
            transactionData.append(contentsOf: tranList)
        } else {
            let tranList = realm.objects(Transaction.self).filter { [self] tran in
                tran.type == type &&
                formatter.string(from: tran.tranDate) == formatter.string(from: queryDate)
            }
            transactionData.append(contentsOf: tranList)
        }
        
        transactionData.sort {
            $0.tranDate > $1.tranDate
        }
        
        tableView.reloadData()
        
    }
    
    func showTotalLB() {
        
        totalSpend = 0
        totalIncome = 0
        balance = 0
        
        for tran in transactionData {
            if tran.type == "spend" {
                totalSpend += tran.amount
            } else {
                totalIncome += tran.amount
            }
        }
        if transactionData.count > 0 {
            balance = totalIncome - totalSpend
            totalSpendLB.text = (totalSpend > 0 ? "-" : "") + String(format: "%.0f %@", locale: Locale.current, totalSpend , globeCurrencyShortSymbol)
            totalIncomeLB.text = (totalIncome > 0 ? "+" : "") + String(format: "%.0f %@", locale: Locale.current, totalIncome , globeCurrencyShortSymbol)
            
            balanceLB.text = balance > 0 ? ("+" + String(format: "%.0f %@", locale: Locale.current, balance , globeCurrencyShortSymbol)) : (String(format: "%.0f %@", locale: Locale.current, balance , globeCurrencyShortSymbol))
            balanceLB.textColor = balance > 0 ? UIColor(named: "Color30") : .red
            
            totalSpendLB.isHidden = false
            totalIncomeLB.isHidden = false
            lineImageView.isHidden = false
            balanceLB.isHidden = false
            
        } else {
            totalSpendLB.isHidden = true
            totalIncomeLB.isHidden = true
            lineImageView.isHidden = true
            balanceLB.isHidden = true
        }
    }
    
    func searchTransaction() {
    
        let query = searchController.searchBar.text
        if query == nil || query == "" {
            getAllData()
        } else {

            transactionData.removeAll()
            if type == "all" {
                let tranQuery = realm.objects(Transaction.self).where { tran in
                    tran.note.contains(query!, options: .caseInsensitive) ||
                    tran.subItem.name.contains(query!, options: .caseInsensitive) ||
                    tran.subItem.item.name.contains(query!, options: .caseInsensitive)
                }.filter { [self] tran in
                    formatter.string(from: tran.tranDate) == formatter.string(from: queryDate)
                }
                transactionData.append(contentsOf: tranQuery)
            } else {
                let tranQuery = realm.objects(Transaction.self).where { tran in
                    tran.type == type &&
                    (tran.note.contains(query!, options: .caseInsensitive) ||
                    tran.subItem.name.contains(query!, options: .caseInsensitive) ||
                    tran.subItem.item.name.contains(query!, options: .caseInsensitive))
                }.filter { [self] tran in
                    formatter.string(from: tran.tranDate) == formatter.string(from: queryDate)
                }
                transactionData.append(contentsOf: tranQuery)
            }

            transactionData.sort {
                $0.tranDate > $1.tranDate
            }
            
            tableView.reloadData()
        }
        
        showTotalLB()
    }
    
    @IBAction func tapSegmentControll(_ sender: Any) {
        
        let font = UIFont.boldSystemFont(ofSize: 18)
        //let font = UIFont(name: "Snell Roundhand Bold", size: 22)
        let selected0Atribute: [NSAttributedString.Key: Any] = [.font: font as Any, .foregroundColor: UIColor.red]
        let selected1Atribute: [NSAttributedString.Key: Any] = [.font: font as Any, .foregroundColor: UIColor(named: "Color30") ?? "system green"]
        let selected2Atribute: [NSAttributedString.Key: Any] = [.font: font as Any, .foregroundColor: UIColor.black]
        if segmentControl.selectedSegmentIndex == 0 {
            segmentControl.selectedSegmentTintColor = UIColor(named: "Segment0")
            segmentControl.setTitleTextAttributes(selected0Atribute, for: .selected)
            type = "spend"
        } else if segmentControl.selectedSegmentIndex == 1 {
            segmentControl.selectedSegmentTintColor = UIColor(named: "Segment1")
            segmentControl.setTitleTextAttributes(selected1Atribute, for: .selected)
            type = "income"
        } else {
            segmentControl.selectedSegmentTintColor = UIColor.systemGray4
            segmentControl.setTitleTextAttributes(selected2Atribute, for: .selected)
            type = "all"
        }
        
        searchTransaction()
    }
}

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        let data = transactionData[indexPath.row]
        
        cell.setData(imageName: data.subItem!.iconName,
                     colorName: data.subItem!.colorName,
                     title: data.subItem!.name,
                     note: data.note,
                     tranDate: data.tranDate,
                     walletName: data.wallet!.name,
                     walletColor: data.wallet!.colorName,
                     amount: data.amount,
                     type: data.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddTranViewController()
        let data = transactionData[indexPath.row]
        vc.title = "🔍 Chi tiết giao dịch"
        vc.actionType = "View"
        vc.amount = data.amount
        vc.note = data.note ?? ""
        vc.tranDate = data.tranDate
        vc.transactionData.removeAll()
        vc.transactionData.append(data)
        vc.subItemData.removeAll()
        vc.subItemData.append(data.subItem!)
        vc.walletData.removeAll()
        vc.walletData.append(data.wallet!)
        
        vc.passData = {
            self.getAllData()
            self.tableView.reloadData()
        }
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BookViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        checkShowSearchBar = false
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "magnifyingglass")
    }
}

extension BookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTransaction()
    }
}
