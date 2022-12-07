//
//  EditSubItemViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 21/11/2022.
//

import UIKit

class EditSubItemViewController: UIViewController {

    var itemIconName: String = ""
    var itemColorName: String = ""
    var itemName: String = ""
    var type: String = ""
    var subItemIconName: String = ""
    var subItemColorName: String = ""
    var subItemName: String = ""
    var budgetAmount: Double = 0
    var useColorItem: Bool = false
    var actionType: String = ""
    var changeItemData: [Item] = []
    var checkChangeItem: Bool = false
    var selectedColorIndex: IndexPath = []
    var passData: (()-> Void)?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLB: UILabel!
    @IBOutlet weak var subItemImageView: UIImageView!
    @IBOutlet weak var subItemNameLB: UILabel!
    @IBOutlet weak var editSubItemNameBtn: UIButton!
    @IBOutlet weak var budgetTF: UITextField!
    @IBOutlet weak var colorSwitch: UISwitch!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var budImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTF.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        colorCollectionView.backgroundColor = .systemGray6
        colorCollectionView.clipsToBounds = true
        colorCollectionView.layer.cornerRadius = 6
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .done, target: self,
                                                            action: #selector(saveAction))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "trash"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(deleteSubItem)))
        
        
        setupView()
        tapImageView()
    }

    @objc func deleteSubItem() {
        
        let alertConfirm = UIAlertController(title: "Xác nhận",
                                      message: "Bạn có chắc chắn muốn xoá danh mục con này ?",
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

        useColorItem = false
        colorSwitch.isOn = false
        
        itemImageView.image = UIImage(systemName: itemIconName)
        itemImageView.tintColor = UIColor(named: itemColorName)
        itemImageView.contentMode = .scaleToFill
        itemNameLB.text = itemName
        
        if let image = UIImage(systemName: subItemIconName) {
            subItemImageView.image = image
        } else {
            subItemImageView.image = UIImage(named: subItemIconName)
        }
        subItemImageView.tintColor = UIColor(named: subItemColorName)
        subItemImageView.contentMode = .scaleToFill
        subItemNameLB.text = subItemName
        editSubItemNameBtn.setTitle("", for: .normal)
        
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = itemImageView.bounds.height/2
        
        budImageView.clipsToBounds = true
        budImageView.layer.cornerRadius = budImageView.bounds.height/2
        if type == "spend" {
            budImageView.image = UIImage(named: "budgetgreen")
            budgetTF.placeholder = "Đặt hạn mức chi"
        } else {
            budImageView.image = UIImage(named: "budgetred")
            budgetTF.placeholder = "Đặt hạn mức thu"
        }
        
        subItemImageView.clipsToBounds = true
        subItemImageView.layer.cornerRadius = subItemImageView.bounds.height/2
        
        budgetTF.clipsToBounds = true
        budgetTF.layer.cornerRadius = 12
        
        if budgetAmount > 0 {
            budgetTF.text = String(format: "%.0f %@", locale: Locale.current, budgetAmount , globeCurrencyShortSymbol)
        }
        
    }

    func refreshItem() {
        let data = changeItemData[0]
        itemName = data.name
        itemIconName = data.iconName
        itemColorName = data.colorName
        itemImageView.image = UIImage(systemName: itemIconName)
        itemImageView.tintColor = UIColor(named: itemColorName)
        itemImageView.contentMode = .scaleToFill
        itemNameLB.text = itemName
    }
    
    func tapImageView() {
        subItemImageView.isUserInteractionEnabled = true
        subItemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapeImageView)))
    }
    
    @objc func actionTapeImageView() {
        let vc = IconListViewController()
        vc.title = "Chọn biểu tượng"
        vc.iconName = subItemIconName
        vc.colorName = subItemColorName
        vc.hidesBottomBarWhenPushed.toggle()
        vc.passData = {
            self.subItemIconName = iconList[vc.selectedIndex!]
            if let img = UIImage(named: self.subItemIconName) {
                self.subItemImageView.image = img
            } else {
                self.subItemImageView.image = UIImage(systemName: self.subItemIconName)
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapChangeItemButton(_ sender: Any) {
        let vc = ItemListViewController()
        vc.callModule = "ChangeItem"
        vc.title = "Thay đổi danh mục"
        vc.navigationItem.rightBarButtonItems?.remove(at: 1)
        vc.passData = {
            self.changeItemData.removeAll()
            self.changeItemData.append(vc.itemData[vc.itemIndex])
            self.refreshItem()
            self.checkChangeItem = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapColorSwitch(_ sender: UISwitch) {
        if sender.isOn {
            useColorItem = true
            subItemColorName = itemColorName
            subItemImageView.tintColor = UIColor(named: subItemColorName)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            colorCollectionView.isUserInteractionEnabled = false
        } else {
            useColorItem = false
            colorCollectionView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func tapEditNameButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sửa tên tiểu mục ",
                                      message: .none,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.subItemNameLB.text
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
            if self.subItemNameLB.text != text {
                self.subItemNameLB.text = text
                self.subItemName = text
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            }))
        
        present(alert, animated: true)
    }
    
}

extension EditSubItemViewController: UITextFieldDelegate {
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

extension EditSubItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension EditSubItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.bounds.width - 30)/4, height: (collectionView.bounds.height - 50)/6)

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
            
            subItemColorName = "Color" + (indexPath.item < 9 ? "0\(indexPath.item + 1)" : "\(indexPath.item + 1)")
            
            subItemImageView.tintColor = UIColor(named: subItemColorName)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .black
            
            if selectedColorIndex != [] {
                collectionView.cellForItem(at: selectedColorIndex)?.backgroundColor = .systemGray6
            }
            
            selectedColorIndex = indexPath
        }

    }
}
