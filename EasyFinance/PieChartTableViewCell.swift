//
//  PieChartTableViewCell.swift
//  EasyFinance
//
//  Created by Quang Lan on 07/12/2022.
//

import UIKit
import RealmSwift
import Charts

class PieChartTableViewCell: UITableViewCell {

    static var identifier = "PieChartTableViewCell"

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    
    let formatter = DateFormatter()
    var queryDate: Date = Date()
    var type: String = "spend"
    var itemData: [Item] = []
    var pieChart = PieChartView()
    var colors: [UIColor] = []
    var totalAmount: Double = 0
    var totalSpend: Double = 0
    var totalIncome: Double = 0
    var refreshData: (()->Void)?
    let realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.dateFormat = "MM-yyyy"
        dateLB.text = formatter.string(from: queryDate)
        dateView.clipsToBounds = true
        dateView.layer.cornerRadius = 8
        getAllData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    
    static func nib()-> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
    @IBAction func tapPreviousMonth(_ sender: Any) {
        let currentDay = queryDate
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = -1
        let preDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: preDay)
        queryDate = preDay
        pieChart.removeFromSuperview()
        pieChartView.reloadInputViews()
        getAllData()
    }
    
    @IBAction func tapNextMonth(_ sender: Any) {
        let currentDay = queryDate
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = 1
        let nextDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: nextDay)
        queryDate = nextDay

        pieChart.removeFromSuperview()
        pieChartView.reloadInputViews()

        getAllData()
        
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
        
        createPieChart()

    }
    
    func createPieChart() {
        pieChart = PieChartView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: pieChartView.bounds.width,
                                                  height: pieChartView.bounds.height))
        pieChartView.addSubview(pieChart)
        
        var pieEntry = [PieChartDataEntry]()
        
        colors.removeAll()
        
        if type == "all" {
            if itemData.count > 0 {
                totalSpend = 0
                totalIncome = 0
                
                for item in itemData {
                    if item.type == "spend" {
                        totalSpend += item.amount
                    } else {
                        totalIncome += item.amount
                    }
                }
                
                pieEntry.append(
                    PieChartDataEntry(value: totalSpend,
                                      label: "Chi tiền")
                )
                pieEntry.append(
                    PieChartDataEntry(value: totalIncome,
                                      label: "Thu tiền")
                )
                
                colors.append(UIColor.red)
                colors.append(UIColor(named: "Color30")!)
                
                totalAmount = totalIncome - totalSpend
            }
            
        } else {
            for i in 0..<itemData.count {
                totalAmount += itemData[i].amount
                pieEntry.append(
                    PieChartDataEntry(value: itemData[i].amount,
                                      label: itemData[i].name)
                )
                colors.append(UIColor(named: itemData[i].colorName)!)
            }
        }
        let chartDataSet = PieChartDataSet(entries: pieEntry, label: "")
        chartDataSet.colors = colors
        let data = PieChartData(dataSet: chartDataSet)
        pieChart.data = data
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.maximumFractionDigits = 0
        format.currencySymbol = globeCurrencyShortSymbol
        let formatter = DefaultValueFormatter(formatter: format)

        pieChart.data?.setValueFormatter(formatter)
        pieChart.legend.horizontalAlignment = .center
    
        if itemData.count > 0 {
            pieChart.centerText = (type == "spend" ? "Chi tiền" : (type == "income" ? "Thu tiền" : "Chi thu")) + "\n" +
                        String(format: "%.0f %@", locale: Locale.current, totalAmount , globeCurrencyShortSymbol)
            
        }
        //pieChart.contentMode = .scaleToFill
    }
    
}

