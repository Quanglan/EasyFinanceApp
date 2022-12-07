//
//  AddTranViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit
import Toast_Swift
import RealmSwift

class AddTranViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var subItemImageView: UIImageView!
    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var amountImageView: UIImageView!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var tranDateImageView: UIImageView!
    @IBOutlet weak var subItemButton: UIButton!
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var tranDateButton: UIButton!
    
    @IBOutlet weak var itemNameLB: UILabel!
    @IBOutlet weak var noteTF: UITextField!
    
    var tranDate: Date = Date()
    var amount: Double = 0
    var note: String = ""
    var type: String = ""
    var actionType: String = ""
    var walletData: [Wallet] = []
    var subItemData: [SubItem] = []
    var transactionData: [Transaction] = []
    var checkChangeSubItem: Bool = false
    var checkChangeWallet: Bool = false
    var passData: (()-> Void)?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTF.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .plain, target: self,
                                                            action: #selector(saveTransaction))
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(deleteTransaction)))
        
        setupView()

    }
    
    @objc func backAction() {
        if actionType == "Add" {
            let vc = TabBarController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func deleteTransaction() {
        let alertConfirm = UIAlertController(title: "Xác nhận",
                                             message: "Bạn có chắc chắn muốn xoá giao dịch này ?",
                                             preferredStyle: .alert)
        alertConfirm.addAction(UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: nil))
        alertConfirm.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [self] _ in
            try! realm.write({
                realm.delete(transactionData[0])
                actionType = "Delete"
                navigationController?.popViewController(animated: true)
                passData?()
            })
        }))
        present(alertConfirm, animated: true)
    }
    
    @objc func saveTransaction() {
        
        if checkValidate() {
            let transaction = Transaction(amount: amount,
                                          note: noteTF.text,
                                          tranDate: tranDate,
                                          subItem: subItemData[0],
                                          wallet: walletData[0])
            if actionType == "Add" {
                try! realm.write({
                    realm.add(transaction)

                    backAction()
                })
            } else {
                try! realm.write({
                    if checkChangeSubItem {
                        transactionData[0].subItem = subItemData[0]
                    }
                    
                    if checkChangeWallet {
                        transactionData[0].wallet = walletData[0]
                    }
                    
                    transactionData[0].amount = amount
                    transactionData[0].note = noteTF.text
                    transactionData[0].tranDate = tranDate
                    
                    navigationController?.popViewController(animated: true)
                    passData?()
                })
            }
        }
        
    }
    
    func checkValidate() -> Bool {
        
        if subItemData.count == 0 {
            view.makeToast("Bạn chưa chọn danh mục")
            return false
        } else if amount <= 0 {
            view.makeToast("Số tiền phải lớn hơn 0")
            return false
        } else {
            return true
        }
    }
    
    func setupView() {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = itemImageView.bounds.height/2
        
        subItemImageView.clipsToBounds = true
        subItemImageView.layer.cornerRadius = subItemImageView.bounds.height/2
        
        tranDateImageView.clipsToBounds = true
        tranDateImageView.layer.cornerRadius = tranDateImageView.bounds.height/2
        
        noteTF.autocorrectionType = .no
        noteTF.autocapitalizationType = .sentences
        
        if actionType == "Add" {
            let wallet = realm.objects(Wallet.self).first
            walletData.removeAll()
            walletData.append(wallet!)
            walletImageView.tintColor = UIColor(named: wallet!.colorName)
            walletButton.setTitle(wallet!.name, for: .normal)
            walletButton.setTitleColor(.black, for: .normal)
            tranDateButton.setTitleColor(.black, for: .normal)
            navigationItem.rightBarButtonItems?.remove(at: 1)
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "xmark")
        } else {
            showSubItemView()
            showWalletView()
            showAmount()
            showDate()
            noteTF.text = note
        }
    }

    func showSubItemView() {
        let data = subItemData[0]
        type = data.item!.type
        if let image = UIImage(named: data.item!.iconName) {
            itemImageView.image = image
        } else {
            itemImageView.image = UIImage(systemName: data.item!.iconName)
        }
        
        itemImageView.tintColor = UIColor(named: data.item!.colorName)
        itemButton.setTitle(data.item!.name, for: .normal)
        itemButton.setTitleColor(.black, for: .normal)
        
        if let image = UIImage(named: data.iconName) {
            subItemImageView.image = image
        } else {
            subItemImageView.image = UIImage(systemName: data.iconName)
        }
        
        subItemImageView.tintColor = UIColor(named: data.colorName)
        subItemButton.setTitle(data.name, for: .normal)
        subItemButton.setTitleColor(.black, for: .normal)
        
        if type == "spend" {
            amountImageView.tintColor = .red
            amountButton.tintColor = .red
        } else {
            amountImageView.tintColor = UIColor(named: "Color30")
            amountButton.tintColor = UIColor(named: "Color30")
        }
    }
    
    @IBAction func tapSubItemButton(_ sender: Any) {
        let vc = ItemListViewController()
        vc.title = "Chọn danh mục"
        vc.passData = {
            
            self.subItemData.removeAll()
            self.subItemData.append(vc.selectedSubItemData.first!)
            self.checkChangeSubItem = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showSubItemView()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWalletView() {
        let data = walletData[0]
        walletImageView.tintColor = UIColor(named: data.colorName)
        walletButton.setTitle(data.name, for: .normal)
        walletButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func tapWalletButton(_ sender: Any) {
        let vc = WalletListViewController()
        vc.title = "💰 Chọn ví tiền"
        vc.passData = {

            self.walletData.removeAll()
            self.walletData.append(vc.walletData[vc.selectedIndex])
            self.checkChangeWallet = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showWalletView()

        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAmount() {
        if amount == 0 {
            amountButton.setTitle("Nhập số tiền", for: .normal)
            //amountButton.setTitleColor(.lightGray, for: .normal)
        } else {
            let amountString = String(format: "%.0f %@", locale: Locale.current, amount , globeCurrencyShortSymbol)
            amountButton.setTitle(amountString, for: .normal)
            //amountButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func tapAmountButton(_ sender: Any) {
        //String(format: "%.0f %@", locale: Locale.current, self.budgetAmount , globeCurrencyShortSymbol)
        let vc = CanculatorViewController()
        vc.title = "💰 Nhập số tiền"
        vc.result = amount
        vc.passData = {
            self.amount = vc.result
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showAmount()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        tranDateButton.setTitle(formatter.string(from: tranDate), for: .normal)
        tranDateButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func tapTranDateButton(_ sender: Any) {
        let vc = CalendarViewController()
        vc.title = "🗓 Chọn ngày"
        vc.tranDate = tranDate
        vc.passData = {
            self.tranDate = vc.tranDate
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showDate()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddTranViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
