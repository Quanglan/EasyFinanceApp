//
//  TranCalendarViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 02/12/2022.
//

import UIKit
import RealmSwift
import FSCalendar

struct TranGroupByDate {
    var tranDate: String = ""
    var totalSpend: Double = 0.0
    var totalIncome: Double = 0.0
    init(tranDate: String, totalSpend: Double, totalIncome: Double) {
        self.tranDate = tranDate
        self.totalSpend = totalSpend
        self.totalIncome = totalIncome
    }
}

class TranCalendarViewController: UIViewController {

    var tranFSCalendar: FSCalendar = FSCalendar()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!

    var queryDate: Date = Date()
    let formatterMonth = DateFormatter()
    let formatterDay = DateFormatter()
    var type: String = ""
    var subItemName: String = ""
    var transactionData: [Transaction] = []
    var tranDayData: [Transaction] = []
    var transactionGroupData: [TranGroupByDate] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatterMonth.dateFormat = "MM-yyyy"
        formatterDay.dateFormat = "dd-MM-yyyy"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.identifier)
        tableView.estimatedRowHeight = 75
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))

        groupTranByDate()
        setupCalendar()
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupCalendar() {

        tranFSCalendar.frame = CGRect(x:0, y: 0, width: backView.bounds.width, height: backView.bounds.height)
        backView.addSubview(tranFSCalendar)
        
        tranFSCalendar.delegate = self
        tranFSCalendar.dataSource = self
        tranFSCalendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        tranFSCalendar.locale = Locale(identifier: "vi")
        tranFSCalendar.scope = .month
        tranFSCalendar.scrollEnabled = false
        tranFSCalendar.placeholderType = .none

        tranFSCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 14.0)
        tranFSCalendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        tranFSCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16.0)
          tranFSCalendar.appearance.todayColor = .systemGreen
        tranFSCalendar.appearance.selectionColor = .yellow
        tranFSCalendar.appearance.titleSelectionColor = .brown
        tranFSCalendar.appearance.titleTodayColor = .white
//        tranFSCalendar.appearance.titleDefaultColor = .systemBlue
        tranFSCalendar.appearance.headerTitleColor = UIColor(named: "Color30")
        tranFSCalendar.appearance.weekdayTextColor = UIColor(named: "Color30")

        tranFSCalendar.setCurrentPage(queryDate, animated: true)
        tranFSCalendar.reloadData()

    }
    
    func groupTranByDate() {
        var strDateGroup: String
        var groupCount: Int = 0
        var totalSpend: Double = 0
        var totalIncome: Double = 0
        
        transactionGroupData.removeAll()
        for i in 0..<transactionData.count {
            strDateGroup = formatterDay.string(from: transactionData[i].tranDate)
            if i == 0 {

                if transactionData[i].type == "spend" {
                    totalSpend = transactionData[i].amount
                    totalIncome = 0
                } else {
                    totalIncome = transactionData[i].amount
                    totalSpend = 0
                }
                
                let tran = TranGroupByDate(tranDate: strDateGroup, totalSpend: totalSpend, totalIncome: totalIncome)
                transactionGroupData.append(tran)
                
            } else {
                if formatterDay.string(from: transactionData[i].tranDate) != formatterDay.string(from: transactionData[i-1].tranDate) {

                    groupCount += 1

                    if transactionData[i].type == "spend" {
                        totalSpend = transactionData[i].amount
                        totalIncome = 0
                    } else {
                        totalIncome = transactionData[i].amount
                        totalSpend = 0
                    }
                    
                    let tran = TranGroupByDate(tranDate: strDateGroup, totalSpend: totalSpend, totalIncome: totalIncome)
                    transactionGroupData.append(tran)
 
                } else {
                    
                    if transactionData[i].type == "spend" {
                        transactionGroupData[groupCount].totalSpend  += transactionData[i].amount
                    } else {
                        transactionGroupData[groupCount].totalIncome += transactionData[i].amount
                    }
                }
                
            }
        }
    }
}

extension TranCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        let spendLB = UILabel(frame: CGRect(x: 0, y: 0 , width: cell.bounds.width, height: 12))
        let incomeLB = UILabel(frame: CGRect(x: 0, y: cell.bounds.height * 0.5 , width: cell.bounds.width, height: 12))
        spendLB.font = UIFont(name: "Noteworthy Bold", size: 8)
        spendLB.textAlignment = .center
        spendLB.textColor = .red
        //incomeLB.font = UIFont.systemFont(ofSize: 8.0, weight: .bold)
        incomeLB.font = UIFont(name: "Noteworthy Bold", size: 8)
        incomeLB.textAlignment = .center
        incomeLB.textColor = UIColor(named: "Color30")
        
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        
        for tran in transactionGroupData {
            if formatterDay.string(from: date) == tran.tranDate {
                spendLB.text = tran.totalSpend == 0 ? "" : numFormatter.string(from: tran.totalSpend as NSNumber)
                incomeLB.text = tran.totalIncome == 0 ? "" : numFormatter.string(from: tran.totalIncome as NSNumber)
            }
        }

        cell.addSubview(spendLB)
        cell.addSubview(incomeLB)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tranDayData.removeAll()
        
        let tranDay = transactionData.filter { [self] tran in
            formatterDay.string(from: tran.tranDate) == formatterDay.string(from: date)
        }
        tranDayData.append(contentsOf: tranDay)
        tranDayData.sort {
            $0.type > $1.type
        }

        tableView.reloadData()
    }
}

extension TranCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tranDayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as! TransactionTableViewCell
        let data = tranDayData[indexPath.row]
        
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

}
