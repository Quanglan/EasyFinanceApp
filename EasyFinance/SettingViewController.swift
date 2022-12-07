//
//  SettingViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import RealmSwift
import CoreLocation

class SettingViewController: UIViewController {

    @IBOutlet weak var budgetImageView: UIImageView!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    @IBOutlet weak var currencyLB: UILabel!
    @IBOutlet weak var settingWalletButton: UIButton!
    @IBOutlet weak var settingCurrency: UIButton!
    
    @IBOutlet weak var currencySymbolLB: UILabel!
    @IBOutlet weak var settingItemButton: UIButton!
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
        selectedTabBarItemIndex = 3
        navigationItem.title = "⚙️ Cài đặt"
        view.addSubview(addTransactionBtn)
        addTransactionBtn.addTarget(self, action: #selector(addTran), for: .touchUpInside)
        budgetImageView.clipsToBounds = true
        budgetImageView.layer.cornerRadius = budgetImageView.bounds.height/2
        currencyImageView.clipsToBounds = true
        currencyImageView.layer.cornerRadius = 10
        getCurrency()
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
    
    func getCurrency() {
        let currency = realm.objects(Currency.self).where { query in
            query.selected == true
        }
        if let data = currency.first {
            currencySymbolLB.text = data.symbol + "\n" + data.shortSymbol
            currencyImageView.image = UIImage(named: data.flagName)
            currencyLB.text = data.country + "\n" + data.name
            globeCurrencyShortSymbol = data.shortSymbol
        }
    }
    
    @IBAction func tapWalletButton(_ sender: Any) {
        let vc = WalletViewController()
        vc.title = "💰 Danh sách ví"
        vc.hidesBottomBarWhenPushed.toggle()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCurrencyButton(_ sender: Any) {
        let vc = CurrencyViewController()
        vc.hidesBottomBarWhenPushed.toggle()
        vc.navigationItem.title = "Tiền tệ"
        vc.passData = {
            let data = vc.currencyData[vc.selectedIndex!]
            self.currencySymbolLB.text = data.symbol + "\n" + data.shortSymbol
            self.currencyLB.text = data.country + "\n" + data.name
            self.currencyImageView.image = UIImage(named: data.flagName)
            globeCurrencyShortSymbol = data.shortSymbol
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapEditItemButton(_ sender: Any) {

        let vc = ItemViewController()
        vc.hidesBottomBarWhenPushed.toggle()
        vc.navigationItem.title = "Danh mục lớn"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

