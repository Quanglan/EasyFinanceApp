//
//  PieChartViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 05/12/2022.
//

import UIKit
import RealmSwift
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var chartView: UIView!
    var chartLabel: String = "màu danh mục"
    var queryDate: Date = Date()
    var type: String = ""
    var itemData: [Item] = []
    var pieChart = PieChartView()
    var colors: [UIColor] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(backAction))
        
        getAllData()
        // Do any additional setup after loading the view.
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
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
        
        createChart()
    }
    
    func createChart() {
        let pieChart = PieChartView(frame: CGRect(x: 0, y: 0, width: chartView.frame.size.width, height: chartView.frame.size.height))
        var entries = [BarChartDataEntry]()
        //entries.append
        for x in 0..<itemData.count {
            entries.append(
                BarChartDataEntry(x: Double(x),
                                  y: itemData[x].amount)
            )
            colors.append(UIColor(named: itemData[x].colorName)!)
        }
        
        let set = PieChartDataSet(entries: entries, label: chartLabel)
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        chartView.addSubview(pieChart)
        //pieChart.center = chartView.center
    }
}

extension PieChartViewController: ChartViewDelegate {
    
}
