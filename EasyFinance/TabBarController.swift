//
//  TabBarController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {

    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()

        tabBar.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.05)

        getCurrency()
        selectedIndex = selectedTabBarItemIndex
    }
    
    func getCurrency() {
        let currency = realm.objects(Currency.self).where { query in
            query.selected == true
        }
        if let data = currency.first {
            globeCurrencyShortSymbol = data.shortSymbol
        }
    }
    
    func setupViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Tổng quan", image: UIImage.init(systemName: "house"), selectedImage: UIImage.init(systemName: "house.fill"))
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        let bookVC = BookViewController()
        bookVC.tabBarItem = UITabBarItem(title: "Sổ giao dịch", image: UIImage.init(systemName: "note.text"), selectedImage: UIImage.init(systemName: "note.text.badge.plus"))
        bookVC.tabBarItem.badgeValue = "N+"
        bookVC.tabBarItem.badgeColor = UIColor.red
        let bookNC = UINavigationController(rootViewController: bookVC)
        
        let transactionVC = TransactionViewController()
        let transactionNC = UINavigationController(rootViewController: transactionVC)
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = UITabBarItem(title: "Cài đặt", image: UIImage.init(systemName: "gearshape"), selectedImage: UIImage.init(systemName: "gearshape.fill"))
        let settingNC = UINavigationController(rootViewController: settingVC)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Tài khoản", image: UIImage.init(systemName: "person"), selectedImage: UIImage.init(systemName: "person.fill"))
        let profileNC = UINavigationController(rootViewController: profileVC)
        
        self.viewControllers = [homeNC, bookNC, transactionNC, settingNC, profileNC]

    }

}
