//
//  BarChartViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 05/12/2022.
//

import UIKit
import RealmSwift
import Charts

class BarChartViewController: UIViewController {

    @IBOutlet weak var chartView: UIView!
    var chartLabel: String = "Danh mục tháng"
    var queryDate: Date = Date()
    var type: String = ""
    var colors: [UIColor] = []
    var itemData: [Item] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let barChart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        var entries = [BarChartDataEntry]()
        //entries.append
        for x in 0..<itemData.count {
            entries.append(
                BarChartDataEntry(x: Double(x),
                                  y: itemData[x].amount)
            )
            colors.append(UIColor(named: itemData[x].colorName)!)
        }
        
        let set = BarChartDataSet(entries: entries, label: chartLabel)
        set.colors = colors
        let data = BarChartData(dataSet: set)
        barChart.data = data
        chartView.addSubview(barChart)
        barChart.center = chartView.center
    }

}
