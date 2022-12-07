//
//  ItemChartViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 06/12/2022.
//

import UIKit
import RealmSwift
import Charts

class ItemChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    let formatter = DateFormatter()
    var queryDate: Date = Date()
    var type: String = ""
    var itemData: [Item] = []
    var pieChart = PieChartView()
    var barChart = BarChartView()
    var colors: [UIColor] = []
    var totalAmount: Double = 0
    var totalSpend: Double = 0
    var totalIncome: Double = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        barChart.delegate = self
        title = (type == "spend" ? "Biểu đồ chi tiền" : (type == "income" ? "Biểu đồ thu tiền" : "Biểu đồ chi thu"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(backAction))
        formatter.dateFormat = "MM-yyyy"
        dateLB.text = formatter.string(from: queryDate)
        dateView.clipsToBounds = true
        dateView.layer.cornerRadius = 8
        
        getAllData()

    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapPreviousMonth(_ sender: Any) {
        let currentDay = queryDate
        var components = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        components.month = -1
        let preDay = calendar.date(byAdding: components, to: currentDay)!
        dateLB.text = formatter.string(from: preDay)
        queryDate = preDay
        barChart.removeFromSuperview()
        pieChart.removeFromSuperview()
        pieChartView.reloadInputViews()
        barChartView.reloadInputViews()

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
        
        barChart.removeFromSuperview()
        pieChart.removeFromSuperview()
        pieChartView.reloadInputViews()
        barChartView.reloadInputViews()

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
        createBarChart()
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
    
    func createBarChart() {
        barChart = BarChartView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: barChartView.bounds.width,
                                                  height: barChartView.bounds.height))
        barChartView.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        var barSet = [BarChartDataSet]()
        
        if type == "all" {
            if itemData.count > 0 {
                entries.append(
                    BarChartDataEntry(x: 0,
                                      y: totalSpend)
                )
                let set1 = BarChartDataSet(entries: entries, label: "Chi tiền")
                colors.append(UIColor.red)
                set1.colors = colors
                barSet.append(set1)
                
                entries.removeAll()
                colors.removeAll()
                entries.append(
                    BarChartDataEntry(x: 1,
                                      y: totalIncome)
                )
                let set2 = BarChartDataSet(entries: entries, label: "Thu tiền")
                colors.append(UIColor(named: "Color30")!)
                set2.colors = colors
                barSet.append(set2)
            }
            
        } else {
            for x in 0..<itemData.count {
                entries.removeAll()
                entries.append(
                    BarChartDataEntry(x: Double(x),
                                      y: itemData[x].amount)
                )
                colors.removeAll()
                colors.append(UIColor(named: itemData[x].colorName)!)
                
                let set = BarChartDataSet(entries: entries, label: itemData[x].name)
                set.colors = colors
                barSet.append(set)
            }
        }
        
        let data = BarChartData(dataSets: barSet)
        barChart.data = data
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.maximumFractionDigits = 0
        format.currencySymbol = globeCurrencyShortSymbol
        let formatter = DefaultValueFormatter(formatter: format)
        barChart.data?.setValueFormatter(formatter)
        
        let valuesNumberFormatter = ChartViewFormatter()
        barChart.leftAxis.valueFormatter = valuesNumberFormatter
        barChart.rightAxis.valueFormatter = valuesNumberFormatter
        
        barChart.legend.horizontalAlignment = .center
 

    }
}

extension ItemChartViewController: ChartViewDelegate {
    
}

//class ChartViewFormatter: NSObject, AxisValueFormatter {
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return String(format: "%.0f %@", locale: Locale.current, value , globeCurrencyShortSymbol)
//    }
//    
//}
