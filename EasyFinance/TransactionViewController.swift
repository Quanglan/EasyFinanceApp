//
//  TransactionViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit

class TransactionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        let vc = AddTranViewController()
        vc.title = "✍️ Giao dịch mới"
        vc.actionType = "Add"
        vc.hidesBottomBarWhenPushed.toggle()

        navigationController?.pushViewController(vc, animated: true)

    }
    
}
