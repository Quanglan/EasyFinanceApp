//
//  SubItemViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 15/11/2022.
//

import UIKit
import RealmSwift

class SubItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var itemData: [Item] = []
    var subItemData: [SubItem] = []
    var objectId: ObjectId!
    var showEditItem: Bool = false
    var checkDeleteItem: Bool = false
    var checkChange: Bool = false
    var passData: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItemTableViewCell.nib(), forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.register(TableHeaderCell.nib(), forCellReuseIdentifier: TableHeaderCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewSubItem))
        
        getAllData()
        
    }
    

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    func getAllData() {
        
        subItemData.removeAll()
        subItemData.append(contentsOf: itemData.first!.subItems)

    }
    
    @objc func addNewSubItem() {
        
        let vc = AddItemViewController()
        vc.title = "Thêm mới danh mục con"
        vc.actionType = "AddSubItem"
        vc.itemName = itemData[0].name
        vc.type = itemData[0].type
        vc.hidesBottomBarWhenPushed.toggle()
        vc.passData = {
            self.addSubItem(name: vc.subItemName,
                         iconName: vc.iconName,
                         colorName: vc.colorName)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSubItem(name: String, iconName: String, colorName: String) {
        
        let newSubItem = SubItem(name: name, iconName: iconName, colorName: colorName, item: itemData[0])
        
        try! realm.write({
            realm.add(newSubItem)
            
        })
    
        subItemData.append(newSubItem)
        tableView.reloadData()
    }
    
    func editSubItem(index: Int) {
        let data = subItemData[index]
        let vc = EditSubItemViewController()

        vc.itemIconName = itemData.first!.iconName
        vc.itemColorName = itemData.first!.colorName
        vc.itemName = itemData.first!.name
        vc.type = itemData.first!.type
        vc.subItemIconName = data.iconName
        vc.subItemColorName = data.colorName
        vc.subItemName = data.name
        vc.title = "Danh mục con"
        vc.budgetAmount = data.budget

        vc.passData = {
            
            if vc.actionType == "Update" {
                try! self.realm.write({

                    data.name = vc.subItemName
                    data.colorName = vc.subItemColorName
                    data.budget = vc.budgetAmount
                    if vc.checkChangeItem {
                        data.item = vc.changeItemData[0]
                    }
                })
                
                //self.tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
                self.getAllData()
                self.tableView.reloadData()
                
            } else if vc.actionType == "Delete" {
                self.deleteSubItem(index: index)
            }
        }
        self.checkChange = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editItem(index: Int) {
        
        let data = itemData[index]
        let vc = EditItemViewController()
        
        vc.iconName = data.iconName
        vc.colorName = data.colorName
        vc.itemName = data.name
        vc.type = data.type
        vc.title = "Danh mục cha"
        vc.budgetAmount = data.budget
        
        vc.passData = {
            if vc.actionType == "Update" {
                try! self.realm.write({
                    
                    data.name = vc.itemName
                    data.colorName = vc.colorName
                    data.budget = vc.budgetAmount

                    if vc.applyColorSubItem == true {
                        
                        for i in 0..<data.subItems.count {
                            data.subItems[i].colorName = vc.colorName
                        }
                        self.tableView.reloadData()
                    }

                })

                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
            } else if vc.actionType == "Delete" {
                self.deleteItem(index: index)
            }
        }
        self.checkChange = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteSubItem(index: Int) {
                
        let deleteSubItem = subItemData[index]

        let checkTransaction = deleteSubItem.transactions.count
        if checkTransaction == 0 {
            
            try! realm.write({
                realm.delete(deleteSubItem)
            })
            subItemData.remove(at: index)
            //tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .none)
            tableView.reloadData()
            
        } else {
            
            let alert = UIAlertController(title: "Lỗi", message: "Không thể xoá được danh mục con khi vẫn còn chứa các giao dịch", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }

    }
    
    func deleteItem(index: Int) {

            self.checkDeleteItem = true
            self.navigationController?.popViewController(animated: true)
            self.passData?()
    }
}

extension SubItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemData.count
        } else {
            return subItemData.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TableHeaderCell.identifier) as! TableHeaderCell

        if section == 0 {

            headerCell.setData(title: "Danh mục lớn", showButton: false)

        } else {

            headerCell.setData(title: "Danh mục con", showButton: false)
        }

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        
        if indexPath.section == 0 {
            
            let data = itemData[indexPath.row]
            cell.setData(imageName: data.iconName,
                         colorName: data.colorName,
                         title: data.name,
                         budget: data.budget,
                         amount: data.amount,
                         type: data.type,
                         editBtn: showEditItem)
            
            cell.editButtonHandler = { [weak self] in
                
                self?.editItem(index: indexPath.row)
            }
            
        } else {
            let data = subItemData[indexPath.row]

            cell.setData(imageName: data.iconName,
                         colorName: data.colorName,
                         title: data.name,
                         budget: data.budget,
                         amount: data.amount,
                         type: itemData[0].type,
                         editBtn: showEditItem)
            
            cell.editButtonHandler = { [weak self] in
                
                self?.editSubItem(index: indexPath.row)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.editItem(index: indexPath.row)
        } else {
            self.editSubItem(index: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Sửa") { [self] action, view, complete in
            if indexPath.section == 0 {
                self.editItem(index: indexPath.row)
            } else {
                self.editSubItem(index: indexPath.row)
            }
            complete(true)
        }
        
        edit.image = UIImage(systemName: "pencil.and.outline")
        edit.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .normal, title: "Xoá") { [self] action, view, complete in

            let alertConfirm = UIAlertController(title: "Xác nhận",
                                          message: "Bạn có chắc chắn muốn xoá danh mục này ?",
                                          preferredStyle: .alert)
            
            alertConfirm.addAction(UIAlertAction(title: "Huỷ bỏ",
                                          style: .cancel,
                                          handler: nil))
            
            alertConfirm.addAction(UIAlertAction(title: "Đồng ý",
                                          style: .default,
                                          handler: {_ in

                if indexPath.section == 0 {

                        self.checkDeleteItem = true
                        self.navigationController?.popViewController(animated: true)
                        self.passData?()
                    
                } else {
                    
                        self.deleteSubItem(index: indexPath.row)
                    
                }
                
                complete(true)
                
                }))
            
            present(alertConfirm, animated: true)
            complete(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: showEditItem ? [delete] : [delete, edit])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
        
    }
}
