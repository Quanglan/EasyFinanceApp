//
//  CurrencyViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import UIKit
import RealmSwift

class CurrencyViewController: UIViewController {

    var currencyData: [Currency] = []
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var passData: (()->Void)?
    var originIndex: Int?
    var selectedIndex: Int?
//    var checkCancel: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyTableViewCell.nib(), forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        tableView.estimatedRowHeight = 60
        getAllData()
        tableView.reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .done, target: self,
                                                            action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func backAction() {
       
        restoreCurrency()
        navigationController?.popViewController(animated: true)

    }
    
    func restoreCurrency() {
        if originIndex != selectedIndex {
            try! realm.write({
                currencyData[selectedIndex!].selected = false
                currencyData[originIndex!].selected = true
            })
        }
    }
    
    @objc func saveAction() {
        
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    func getAllData() {
        let currencyList = realm.objects(Currency.self)
        currencyData.removeAll()
        currencyData.append(contentsOf: currencyList)
        for i in 0..<currencyData.count {
            if currencyData[i].selected == true {
                selectedIndex = i
                originIndex = i
                return
            }
        }
    }

}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as! CurrencyTableViewCell
        let data = currencyData[indexPath.row]
        cell.setData(country: data.country,
                     name: data.name,
                     symbol: data.symbol,
                     shortSymbol: data.shortSymbol,
                     flagName: data.flagName)
        cell.checkSelected(selected: data.selected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            try! realm.write({
                if selectedIndex != nil {
                    currencyData[selectedIndex!].selected = false
                    tableView.reloadRows(at: [IndexPath(row: selectedIndex!, section: 0)], with: .none)
                }
                currencyData[indexPath.row].selected = true
                tableView.reloadRows(at: [indexPath], with: .none)
                selectedIndex = indexPath.row
                navigationItem.rightBarButtonItem?.isEnabled = true
            })
        }
    }
    
}


