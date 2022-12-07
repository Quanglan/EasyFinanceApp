//
//  SubItemChartViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 07/12/2022.
//

import UIKit
import RealmSwift
import Charts

class SubItemChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    
    let formatter = DateFormatter()
    var queryDate: Date = Date()
    var type: String = ""
    var itemData: [Item] = []
    var subItemData: [SubItem] = []
    var pieChart = PieChartView()
    var barChart = BarChartView()
    var colors: [UIColor] = []
    var tempColors: [UIColor] = []
    var totalAmount: Double = 0
    var totalSpend: Double = 0
    var totalIncome: Double = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        barChart.delegate = self
        title = "Biểu đồ: " + itemData[0].name
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
        subItemData.removeAll()
        
        let subItemList = itemData[0].subItems.filter { subItem in
            subItem.amount > 0
        }
        
        subItemData.append(contentsOf: subItemList)
        
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
        tempColors.removeAll()
        tempColors.append(contentsOf: ChartColorTemplates.joyful())
        totalAmount = itemData[0].amount
        
        for i in 0..<subItemData.count {

            pieEntry.append(
                PieChartDataEntry(value: subItemData[i].amount,
                                  label: subItemData[i].name)
            )
            //colors.append(UIColor(named: subItemData[i].colorName)!)
            colors.append(tempColors[i])
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
    
        if subItemData.count > 0 {
            pieChart.centerText = itemData[0].name + "\n" +
                        String(format: "%.0f %@", locale: Locale.current, totalAmount , globeCurrencyShortSymbol)
            
        }

    }
    
    func createBarChart() {
        barChart = BarChartView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: barChartView.bounds.width,
                                                  height: barChartView.bounds.height))
        barChartView.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        var barSet = [BarChartDataSet]()
        

        for x in 0..<subItemData.count {
            entries.removeAll()
            entries.append(
                BarChartDataEntry(x: Double(x),
                                  y: subItemData[x].amount)
            )
            colors.removeAll()
            //colors.append(UIColor(named: subItemData[x].colorName)!)
            colors.append(tempColors[x])
            
            let set = BarChartDataSet(entries: entries, label: subItemData[x].name)
            set.colors = colors
            barSet.append(set)
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

extension SubItemChartViewController: ChartViewDelegate {
    
}

