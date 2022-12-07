//
//  SubItemRptViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 04/12/2022.
//

import UIKit
import RealmSwift

class SubItemRptViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateBarView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var viewChartButton: UIButton!
    @IBOutlet weak var typeLB: UILabel!

    
    var totalAmount: Double = 0
    var itemData: [Item] = []
    var subItemData: [SubItem] = []
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
        navigationItem.title = "🔍 Chi tiết danh mục"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableHeaderCell.nib(), forCellReuseIdentifier: TableHeaderCell.identifier)
        tableView.register(ItemRptTableViewCell.nib(), forCellReuseIdentifier: ItemRptTableViewCell.identifier)
        tableView.estimatedRowHeight = 66
        

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(backAction))
        
    
        setupView()
        getAllData()

    }
    
    func setupView() {
        
        dateBarView.clipsToBounds = true
        dateBarView.layer.cornerRadius = 8
        formatter.dateFormat = "MM-yyyy"
        dateLB.text = formatter.string(from: queryDate)
        viewChartButton.clipsToBounds = true
        viewChartButton.layer.cornerRadius = 8
        typeLB.text = itemData[0].type == "spend" ? "🛍 Chi tiền" : "💰 Thu tiền"
        typeLB.textColor = itemData[0].type == "spend" ? .red : UIColor(named: "Color30")
        typeLB.backgroundColor = itemData[0].type == "spend" ? UIColor(named: "Segment0") : UIColor(named: "Segment1")
        typeLB.clipsToBounds = true
        typeLB.layer.cornerRadius = 8
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
        let vc = SubItemChartViewController()
        vc.queryDate = queryDate
        vc.itemData.removeAll()
        vc.itemData.append(itemData[0])
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
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
        subItemData.removeAll()
        
        let subItemList = itemData[0].subItems.filter { subItem in
            subItem.amount > 0
        }
        
        subItemData.append(contentsOf: subItemList)
        tableView.reloadData()

    }
    
}

extension SubItemRptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemData.count
        } else {
            return subItemData.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderCell.identifier) as! TableHeaderCell

        if section == 0 {

            headerCell.setData(title: "Danh mục lớn", showButton: false)

        } else {

            headerCell.setData(title: "Danh mục con", showButton: false)
        }

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemRptTableViewCell.identifier, for: indexPath) as! ItemRptTableViewCell
        
        if indexPath.section == 0 {
            let data = itemData[indexPath.row]
            cell.setData(titleText: data.name,
                         iconName: data.iconName,
                         colorName: data.colorName,
                         budget: data.budget,
                         amount: data.amount,
                         totalSpend: data.amount,
                         totalIncom: data.amount,
                         type: data.type,
                         showPercent: false)
        } else {
            let data = subItemData[indexPath.row]
            cell.setData(titleText: data.name,
                         iconName: data.iconName,
                         colorName: data.colorName,
                         budget: data.budget,
                         amount: data.amount,
                         totalSpend: itemData[0].amount,
                         totalIncom: itemData[0].amount,
                         type: data.item!.type,
                         showPercent: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = TranRptViewController()
            let data = subItemData[indexPath.row]
            vc.queryDate = queryDate
            vc.subItemData.removeAll()
            vc.subItemData.append(data)
            vc.hidesBottomBarWhenPushed.toggle()
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


