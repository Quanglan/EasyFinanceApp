//
//  WalletListViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit
import RealmSwift

class WalletListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var walletData: [Wallet] = []
    var passData: (()-> Void)?
    var selectedIndex: Int = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableHeaderCell.nib(), forCellReuseIdentifier: TableHeaderCell.identifier)
        tableView.register(WalletTableViewCell.nib(), forCellReuseIdentifier: WalletTableViewCell.identifier)
        tableView.estimatedRowHeight = 95
        getAllData()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addNewWallet))
        
        getAllData()
        
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewWallet() {
        let colorNum = Int.random(in: 1...32)
        let colorName = colorNum < 10 ? "Color0\(colorNum)" : "Color\(colorNum)"
        let vc = EditWalletViewController()
        vc.colorName = colorName
        vc.actionType = "Add"
        vc.passData = {
            self.addWallet(name: vc.name,
                           note: vc.note,
                           colorName: vc.colorName,
                           openBal: vc.openBal)
 
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func addWallet(name: String, note: String?, colorName: String, openBal: Double) {
        let wallet = Wallet(name: name, note: note ?? "", colorName: colorName, openBal: openBal)
        try! realm.write({
            realm.add(wallet)
        })
        walletData.append(wallet)
        tableView.insertRows(at: [IndexPath(row: walletData.count-1, section: 1)], with: .none)
    }
    
    func getAllData() {
        let wallets = realm.objects(Wallet.self)
        walletData.removeAll()
        walletData.append(contentsOf: wallets)
    }

}

extension WalletListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return walletData.count
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderCell.identifier) as! TableHeaderCell

        if section == 0 {

            headerCell.setData(title: "Tổng hợp ví", showButton: false)

        } else {

            headerCell.setData(title: "Danh sách ví", showButton: false)
        }

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier,
                                                 for: indexPath) as! WalletTableViewCell
        
        
        if indexPath.section == 0 {
            
            var totalOpenBal: Double = 0
            var totalDebit: Double = 0
            var totalCredit: Double = 0
            var totalCurrentBal: Double = 0
            
            for wallet in walletData {
                totalOpenBal += wallet.openBal
                totalDebit += wallet.totalDebit
                totalCredit += wallet.totalCredit
                totalCurrentBal += wallet.currentBal
            }
            
            cell.setValue(walletName: "Ví tổng",
                          iconName: "wallet1",
                          colorName: "Color30",
                          openBal: totalOpenBal,
                          totalDebit: totalDebit,
                          totalCredit: totalCredit,
                          currentBal: totalCurrentBal,
                          showSumIcon: true)
            
        } else {
            
            let data = walletData[indexPath.row]
            cell.setValue(walletName: data.name + (data.note != "" ? "\n" + data.note : ""),
                          iconName: "creditcard.fill",
                          colorName: data.colorName,
                          openBal: data.openBal,
                          totalDebit: data.totalDebit,
                          totalCredit: data.totalCredit,
                          currentBal: data.currentBal,
                          showSumIcon: false)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return walletData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier,
//                                                 for: indexPath) as! WalletTableViewCell
//        let data = walletData[indexPath.row]
//
//        cell.walletNameLB.text = data.name + (data.note != "" ? "\n" + data.note : "")
//
//        cell.iconImageView.image = UIImage(systemName: "creditcard.fill")
//        cell.iconImageView.tintColor = UIColor(named: data.colorName)
//        cell.openBalLB.text = String(format: "%.0f %@", locale: Locale.current, data.openBal , globeCurrencyShortSymbol)
//        cell.totalSpendLB.text = String(format: "%.0f %@", locale: Locale.current, data.totalDebit , globeCurrencyShortSymbol)
//        cell.totalIncomeLB.text = String(format: "%.0f %@", locale: Locale.current, data.totalCredit , globeCurrencyShortSymbol)
//        cell.currentBalLB.text = String(format: "%.0f %@", locale: Locale.current, data.currentBal , globeCurrencyShortSymbol)
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedIndex = indexPath.row
            navigationController?.popViewController(animated: true)
            passData?()
        }
    }
    
}

