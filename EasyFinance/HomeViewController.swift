//
//  HomeViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
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
    
    var walletData: [Wallet] = []
    var passData: (()-> Void)?
    var selectedIndex: Int = 0
//    var isChartData: Bool = true
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PieChartTableViewCell.nib(), forCellReuseIdentifier: PieChartTableViewCell.identifier)
        tableView.register(TableHeaderCell.nib(), forCellReuseIdentifier: TableHeaderCell.identifier)
        tableView.register(WalletTableViewCell.nib(), forCellReuseIdentifier: WalletTableViewCell.identifier)
        tableView.estimatedRowHeight = 500
        tableView.reloadData()
        navigationItem.title = "🏦 Tổng quan"
        selectedTabBarItemIndex = 0
        view.addSubview(addTransactionBtn)
        addTransactionBtn.addTarget(self, action: #selector(addTran), for: .touchUpInside)
    }

    @objc func addTran() {
        let vc = AddTranViewController()
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTransactionBtn.frame = CGRect(x: (view.frame.size.width - 60)/2,
                                         y: view.frame.size.height - 85, width: 60, height: 60)
    }
    
//    func getAllData() {
//        let wallets = realm.objects(Wallet.self)
//        walletData.removeAll()
//        walletData.append(contentsOf: wallets)
//    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderCell.identifier) as! TableHeaderCell

        if section == 0 {

            headerCell.setData(title: "Ví của tôi", showButton: true)
            headerCell.tapShowDetailButton = {
                let vc = WalletViewController()
                vc.title = "💰 Danh sách ví"
                vc.hidesBottomBarWhenPushed.toggle()
                self.navigationController?.pushViewController(vc, animated: true)
            }

        } else {

            headerCell.setData(title: "Thu chi trong tháng", showButton: true)
        }

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 86
        } else {

            return 500

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier,
                                                     for: indexPath) as! WalletTableViewCell

            let walletBalance = getWalletBalance()
            
            cell.setValue(walletName: "Ví tổng",
                          iconName: "wallet1",
                          colorName: "Color30",
                          openBal: walletBalance.0,
                          totalDebit: walletBalance.1,
                          totalCredit: walletBalance.2,
                          currentBal: walletBalance.3,
                          showSumIcon: true)
            
            return cell
        } else {
            let pieCell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier,
                                                     for: indexPath) as! PieChartTableViewCell
            pieCell.refreshData = {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
            }
            return pieCell
        }
        
    }
    
    
}
