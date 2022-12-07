//
//  EditWalletViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 24/11/2022.
//

import UIKit
import Toast_Swift
import RealmSwift


class EditWalletViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var noteTF: UITextField!
    @IBOutlet weak var openBalTF: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var walletImageView: UIImageView!
    var name: String = ""
    var note: String = ""
    var colorName: String = ""
    var openBal: Double = 0
    var actionType: String = ""
    var selectedColorIndex: IndexPath = []
    var passData: (()->Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        openBalTF.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        colorCollectionView.backgroundColor = .systemGray6
        colorCollectionView.clipsToBounds = true
        colorCollectionView.layer.cornerRadius = 6
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .done, target: self,
                                                            action: #selector(saveAction))
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(deleteWallet)))
        
        
        setupView()
        
    }

    @objc func deleteWallet() {
        
        let alertConfirm = UIAlertController(title: "Xác nhận",
                                      message: "Bạn có chắc chắn muốn xoá ví tiền này ?",
                                      preferredStyle: .alert)
        
        alertConfirm.addAction(UIAlertAction(title: "Huỷ bỏ",
                                      style: .cancel,
                                      handler: nil))
        
        alertConfirm.addAction(UIAlertAction(title: "Đồng ý",
                                      style: .default,
                                      handler: {_ in
            self.actionType = "Delete"
            self.navigationController?.popViewController(animated: true)
            self.passData?()
        }))
        present(alertConfirm, animated: true)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkValidate() -> Bool{
        if nameTF.text?.isBlank == true {
            view.makeToast("Tên ví không được bỏ trống")
            nameTF.becomeFirstResponder()
            return false
        }
        if openBal == 0 {
            view.makeToast("Số dư ban đầu của ví phải lớn hơn 0")
            openBalTF.becomeFirstResponder()
            return false
        }
        
        if selectedColorIndex == [] {
            view.makeToast("Xin mời chọn màu sắc")
            return false
        }
        
        return true
    }
    
    @objc func saveAction() {
        if checkValidate() {
            actionType = "Update"
            name = nameTF.text ?? ""
            note = noteTF.text ?? ""
            navigationController?.popViewController(animated: true)
            passData?()
        }
    }

    func setupView() {
        
        nameTF.becomeFirstResponder()
        
        if actionType == "Add" {
            walletImageView.tintColor = .black
        } else {
            walletImageView.tintColor = UIColor(named: colorName)
        }
        
        nameTF.clipsToBounds = true
        nameTF.layer.cornerRadius = 12
        nameTF.autocorrectionType = .no
        nameTF.autocapitalizationType = .sentences
        
        noteTF.clipsToBounds = true
        noteTF.layer.cornerRadius = 12
        noteTF.autocorrectionType = .no
        noteTF.autocapitalizationType = .sentences
        
        nameTF.text = name
        noteTF.text = note
        if openBal > 0 {
            openBalTF.text = String(format: "%.0f %@", locale: Locale.current, openBal , globeCurrencyShortSymbol)
        } else {
            openBalTF.placeholder = "Nhập số dư ban đầu"
        }
        
        if actionType == "Add" {
            navigationItem.rightBarButtonItems?.remove(at: 1)
        }
    }
    
}

extension EditWalletViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = CanculatorViewController()
        vc.result = openBal
        vc.title = "💰 Nhập số dư ví"
        vc.passData = {
            self.openBal = vc.result
            if vc.result > 0 {
                self.openBalTF.text = String(format: "%.0f %@", locale: Locale.current, self.openBal , globeCurrencyShortSymbol)
            } else {
                self.openBalTF.text = ""
                self.openBalTF.placeholder = "Nhập số dư ban đầu"
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        navigationController?.pushViewController(vc, animated: true)
        textField.endEditing(true)
    }
}

extension EditWalletViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
  
        cell.iconImageView.backgroundColor = UIColor(named: "Color" + (indexPath.item < 9 ? "0\(indexPath.item + 1)" : "\(indexPath.item + 1)"))
        
        cell.iconImageView.clipsToBounds = true
        cell.iconImageView.layer.cornerRadius = 6
        
        return cell
    }
    
}

extension EditWalletViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.bounds.width - 30)/4, height: (collectionView.bounds.height - 70)/8)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Select item \(indexPath.item) name: \(iconList[indexPath.item])")
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        if selectedColorIndex != indexPath {
            
            colorName = "Color" + (indexPath.item < 9 ? "0\(indexPath.item + 1)" : "\(indexPath.item + 1)")

            walletImageView.tintColor = UIColor(named: colorName)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .black
            
            if selectedColorIndex != [] {
                collectionView.cellForItem(at: selectedColorIndex)?.backgroundColor = .systemGray6
            }
            
            selectedColorIndex = indexPath
        }

    }
}
