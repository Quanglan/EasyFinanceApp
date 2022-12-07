//
//  AddItemViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 30/11/2022.
//

import UIKit
import Toast_Swift

class AddItemViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var typeLB: UILabel!
    var selectedIconIndex: IndexPath = []
    var selectedColorIndex: IndexPath = []
    var actionType: String = ""
    var type: String = ""
    var itemName: String = ""
    var subItemName: String = ""
    var iconName: String = ""
    var colorName: String = ""
    var passData: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .plain, target: self,
                                                            action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if type == "spend" {
            if actionType == "AddItem" {
                typeLB.text = "Chi tiền"
            } else {
                typeLB.text = itemName
            }
            typeLB.textColor = .red
            iconImageView.tintColor = .red
        } else {
            if actionType == "AddItem" {
            typeLB.text = "Thu tiền"
            } else {
                typeLB.text = itemName
            }
            typeLB.textColor = UIColor(named: "Color30")
            iconImageView.tintColor = UIColor(named: "Color30")
        }
    }
    
    func setupCollection() {
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        iconCollectionView.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        iconCollectionView.backgroundColor = .systemGray6
        iconCollectionView.clipsToBounds = true
        iconCollectionView.layer.cornerRadius = 6
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(IconCollectionViewCell.nib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        colorCollectionView.backgroundColor = .systemGray6
        colorCollectionView.clipsToBounds = true
        colorCollectionView.layer.cornerRadius = 6
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkValidate() -> Bool {
        
        if nameTF.text!.isEmpty || nameTF.text?.isBlank == true {
            view.makeToast("Tên cho danh mục không được bỏ trống")
            return false
        }
        
        if  selectedIconIndex == [] {
            view.makeToast("Xin mời chọn biểu tượng")
            return false
        } else if selectedColorIndex == [] {
            view.makeToast("Xin mời chọn màu sắc")
            return false
        }
        
        return true
    }
    
    @objc func saveAction() {
        if checkValidate() {
            iconName = iconList[selectedIconIndex.item]

            colorName = "Color" + (selectedColorIndex.item < 9 ? "0\(selectedColorIndex.item + 1)" : "\(selectedColorIndex.item + 1)")
            
            if actionType == "AddItem" {
                itemName = nameTF.text ?? ""
            } else {
                subItemName = nameTF.text ?? ""
            }
            
            navigationController?.popViewController(animated: true)
            passData?()
        }
    }
}

extension AddItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == iconCollectionView {
            return iconList.count
        } else {
            return 32
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.identifier, for: indexPath) as! IconCollectionViewCell
        if collectionView == iconCollectionView {
            cell.setData(iconName: iconList[indexPath.item])
        } else {
            cell.iconImageView.backgroundColor = UIColor(named: "Color" + (indexPath.item < 9 ? "0\(indexPath.item + 1)" : "\(indexPath.item + 1)"))
        }
        
        return cell
    }
    
}

extension AddItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == iconCollectionView {
            return CGSize(width: (collectionView.bounds.width - 50)/6, height: (collectionView.bounds.height - 30)/4)
        } else {
            return CGSize(width: (collectionView.bounds.width - 30)/4, height: (collectionView.bounds.height - 50)/6)
        }
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
        
        if collectionView == iconCollectionView {
            if selectedIconIndex != indexPath {
                if let img = UIImage(named: iconList[indexPath.item]) {
                    iconImageView.image = img
                } else {
                    iconImageView.image = UIImage(systemName: iconList[indexPath.item])
                }
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemPurple
                
                if selectedIconIndex != [] {
                    collectionView.cellForItem(at: selectedIconIndex)?.backgroundColor = .systemGray6
                }
                
                selectedIconIndex = indexPath

            }
            

        } else {
            if selectedColorIndex != indexPath {
                
                iconImageView.tintColor = UIColor(named: "Color" + (indexPath.item < 9 ? "0\(indexPath.item + 1)" : "\(indexPath.item + 1)"))
                
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .black
                
                if selectedColorIndex != [] {
                    collectionView.cellForItem(at: selectedColorIndex)?.backgroundColor = .systemGray6
                }
                
                selectedColorIndex = indexPath
            }
        }
    }
}
