//
//  EditItemViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 16/11/2022.
//

import UIKit

class EditItemViewController: UIViewController {

    var iconName: String = ""
    var colorName: String = ""
    var itemName: String = ""
    var budgetAmount: Double = 0
    var type: String = ""
    var actionType: String = ""
    var selectedColorIndex: IndexPath = []
    var passData: (()-> Void)?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var budgetImageView: UIImageView!
    @IBOutlet weak var itemLB: UILabel!
    @IBOutlet weak var budgetTF: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var editNameButton: UIButton!

    @IBOutlet weak var applyColorSwitch: UISwitch!
    var applyColorSubItem: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetTF.delegate = self
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
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(deleteItem)))
        
        
        setupView()
        tapImageView()
    }

    @objc func deleteItem() {
        
        let alertConfirm = UIAlertController(title: "Xác nhận",
                                      message: "Bạn có chắc chắn muốn xoá danh mục này ?",
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
    
    @objc func saveAction() {
        actionType = "Update"
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    func setupView() {
        
        applyColorSubItem = true
        applyColorSwitch.isOn = true
        
        if let img = UIImage(named: iconName) {
            itemImageView.image = img
        } else {
            itemImageView.image = UIImage(systemName: iconName)
        }
        itemImageView.tintColor = UIColor(named: colorName)
        itemImageView.contentMode = .scaleToFill
        itemLB.text = itemName
        editNameButton.setTitle("", for: .normal)
        
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = itemImageView.bounds.height/2
        
        budgetImageView.clipsToBounds = true
        budgetImageView.layer.cornerRadius = budgetImageView.bounds.height/2
        if type == "spend" {
            budgetImageView.image = UIImage(named: "budgetgreen")
            budgetTF.placeholder = "Đặt hạn mức chi"
        } else {
            budgetImageView.image = UIImage(named: "budgetred")
            budgetTF.placeholder = "Đặt hạn mức thu"
        }
        
        budgetTF.clipsToBounds = true
        budgetTF.layer.cornerRadius = 12
        
        if budgetAmount > 0 {
            budgetTF.text = String(format: "%.0f %@", locale: Locale.current, budgetAmount , globeCurrencyShortSymbol)
        }
        
    }

    func tapImageView() {
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapeImageView)))
    }
    
    @objc func actionTapeImageView() {
        let vc = IconListViewController()
        vc.title = "Chọn biểu tượng"
        vc.iconName = iconName
        vc.colorName = colorName
        vc.hidesBottomBarWhenPushed.toggle()
        vc.passData = {
            self.iconName = iconList[vc.selectedIndex!]
            if let img = UIImage(named: self.iconName) {
                self.itemImageView.image = img
            } else {
                self.itemImageView.image = UIImage(systemName: self.iconName)
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapApplyColorSwitch(_ sender: UISwitch) {
        if sender.isOn {
            applyColorSubItem = true
        } else {
            applyColorSubItem = false
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func tapEditNameButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sửa tên danh mục ",
                                      message: .none,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.itemLB.text
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {_ in
                                                guard let filed = alert.textFields?.first,
                                                let text = filed.text, !text.isBlank else { return }
            if self.itemLB.text != text {
                self.itemLB.text = text
                self.itemName = text
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            }))
        
        present(alert, animated: true)
    }
    
}

extension EditItemViewController: UITextFieldDelegate {
   func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = CanculatorViewController()
        vc.title = "💰 Nhập hạn mức"
        vc.result = budgetAmount
        vc.passData = {
            self.budgetAmount = vc.result
            if vc.result > 0 {
                self.budgetTF.text = String(format: "%.0f %@", locale: Locale.current, self.budgetAmount , globeCurrencyShortSymbol)
            } else {
                self.budgetTF.text = nil
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        navigationController?.pushViewController(vc, animated: true)
        textField.endEditing(true)
    }
}

extension EditItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension EditItemViewController: UICollectionViewDelegateFlowLayout {
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
            
            itemImageView.tintColor = UIColor(named: colorName)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .black
            
            if selectedColorIndex != [] {
                collectionView.cellForItem(at: selectedColorIndex)?.backgroundColor = .systemGray6
            }
            
            selectedColorIndex = indexPath
        }

    }
}
