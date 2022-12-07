//
//  ItemRptViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 03/12/2022.
//

import UIKit
import RealmSwift

class ItemRptViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateBarView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var viewChartButton: UIButton!
    @IBOutlet weak var totalSpendLB: UILabel!
    @IBOutlet weak var totalIncomeLB: UILabel!
    @IBOutlet weak var balanceLB: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    
    var totalSpend: Double = 0
    var totalIncome: Double = 0
    var balance: Double = 0
    var transactionData: [Transaction] = []
    var itemData: [Item] = []
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
        navigationItem.title = "🧾 Tổng hợp danh mục"

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ItemRptTableViewCell.nib(), forCellReuseIdentifier: ItemRptTableViewCell.identifier)
        tableView.estimatedRowHeight = 66
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "creditcard.fill"),
//                                                            style: .plain, target: self,
//                                                            action: #selector(showWallet))
        
//        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle"),
//                                                                   style: .plain, target: self,
//                                                                   action: #selector(showItem)))
//
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(backAction))
        
    
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
        viewChartButton.clipsToBounds = true
        viewChartButton.layer.cornerRadius = 8
    }
    
    @IBAction func tapPreviousMonth(_ sender: Any) {
        let currentDay = queryDate
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = -1
        let preDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: preDay)
        queryDate = preDay
        getAllData()
    }
    
    @IBAction func tapNextMonth(_ sender: Any) {
        let currentDay = queryDate //tranFSCalendar.currentPage
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = 1
        let nextDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: nextDay)
        queryDate = nextDay
        getAllData()
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapViewChartButton(_ sender: Any) {
        let vc = ItemChartViewController()
        vc.type = type
        vc.queryDate = queryDate
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc func showWallet() {
//        let vc = WalletViewController()
//        vc.title = "💰 Danh sách ví"
//        vc.passData = {
//            if vc.checkChange {
//                self.tableView.reloadData()
//            }
//        }
//        vc.hidesBottomBarWhenPushed.toggle()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @objc func showItem() {
//        let vc = ItemViewController()
//        vc.title = "Danh mục lớn"
//        vc.passData = {
//            if vc.checkChange {
//                self.tableView.reloadData()
//            }
//        }
//        vc.hidesBottomBarWhenPushed.toggle()
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    @objc func addTran() {
        let vc = AddTranViewController()
        vc.actionType = "Add"
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTransactionBtn.frame = CGRect(x: (view.frame.size.width - 60)/2,
                                         y: view.frame.size.height - 85, width: 60, height: 60)
    }
    
    func getAllData() {
        globeQueryMonth = queryDate
        itemData.removeAll()
        if type == "all" {
            let itemList = realm.objects(Item.self).filter { item in
                item.amount > 0
            }
            itemData.append(contentsOf: itemList)
        } else {
            let itemList = realm.objects(Item.self).filter { [self] item in
                item.type == type &&
                item.amount > 0
            }
            itemData.append(contentsOf: itemList)
        }
        
        tableView.reloadData()
        showTotalLB()
    }
    
    func showTotalLB() {
        
        totalSpend = 0
        totalIncome = 0
        balance = 0
        
        for item in itemData {
            if item.type == "spend" {
                totalSpend += item.amount
            } else {
                totalIncome += item.amount
            }
        }
        if itemData.count > 0 {
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
        
        getAllData()
    }
}

extension ItemRptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemRptTableViewCell.identifier, for: indexPath) as! ItemRptTableViewCell
        let data = itemData[indexPath.row]
        
        cell.setData(titleText: data.name,
                     iconName: data.iconName,
                     colorName: data.colorName,
                     budget: data.budget,
                     amount: data.amount,
                     totalSpend: totalSpend,
                     totalIncom: totalIncome,
                     type: data.type,
                     showPercent: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubItemRptViewController()
        let data = itemData[indexPath.row]
        vc.queryDate = queryDate
        vc.itemData.removeAll()
        vc.itemData.append(data)
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

