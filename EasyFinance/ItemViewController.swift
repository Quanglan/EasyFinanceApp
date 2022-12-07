//
//  ItemViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 15/11/2022.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var itemData: [Item] = []
    var type: String = ""
    var showEditItem: Bool = false
    var checkChange: Bool = false
    var passData: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globeQueryMonth = Date()
        tableView.register(ItemTableViewCell.nib(), forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addNewItem))
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(showHideEditButtonCell)))
        let font = UIFont.systemFont(ofSize: 17)
        let normalAtribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.gray]
        let font0 = UIFont.boldSystemFont(ofSize: 18)
        let selected0Atribute: [NSAttributedString.Key: Any] = [.font: font0, .foregroundColor: UIColor.red]
        
        segmentControl.setTitleTextAttributes(normalAtribute, for: .normal)
        segmentControl.setTitleTextAttributes(selected0Atribute, for: .selected)
        
        getAllData()
        
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    @objc func showHideEditButtonCell() {
        
        if showEditItem {
            
            showEditItem = false
            navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: "gearshape") //gearshape
            
        } else {
            
            showEditItem = true
            navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: "gearshape.fill") //gearshape.fill
        }
        
        tableView.reloadData()
    }
    
    @objc func addNewItem() {
        let vc = AddItemViewController()
        vc.title = "Thêm mới danh mục"
        vc.actionType = "AddItem"
        vc.type = type
        vc.hidesBottomBarWhenPushed.toggle()
        vc.passData = {
            self.addItem(name: vc.itemName,
                         iconName: vc.iconName,
                         colorName: vc.colorName,
                         type: self.type)
        }
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func addItem(name: String, iconName: String, colorName: String, type: String) {
        
        let newItem = Item(name: name, iconName: iconName, colorName: colorName, type: type)
        
        try! realm.write({
            realm.add(newItem)
        })
        
        itemData.append(newItem)
        tableView.insertRows(at: [IndexPath(row: itemData.count-1, section: 0)], with: .none)
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
                    
                    data.iconName = vc.iconName
                    data.name = vc.itemName
                    data.colorName = vc.colorName
                    data.budget = vc.budgetAmount

                    if vc.applyColorSubItem == true {
                        
                        for i in 0..<(data.subItems.count ) {
                            data.subItems[i].colorName = vc.colorName
                        }
                    }

                })
                self.checkChange = true
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
            } else if vc.actionType == "Delete" {
                self.deleteItem(index: index)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteItem(index: Int) {
        let deleteItem = itemData[index]
        let checkSubItem = deleteItem.subItems.count
        
        if checkSubItem == 0 {
            
            try! realm.write({
                realm.delete(deleteItem)
            })
            itemData.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
            
        } else {
            
            let alert = UIAlertController(title: "Lỗi", message: "Không thể xoá được danh mục khi vẫn còn chứa các danh mục con", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func getAllData() {
        
        if segmentControl.selectedSegmentIndex == 0 {
            type = "spend"
        } else {
            type = "income"
        }
        
        let itemList = realm.objects(Item.self).where { item in
            item.type == type
        }
        
        itemData.removeAll()
        itemData.append(contentsOf: itemList)
    }

    @IBAction func tapSegmentControll(_ sender: Any) {

        getAllData()
        tableView.reloadData()
        
        let font = UIFont.boldSystemFont(ofSize: 18)
        let selected0Atribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.red]
        let selected1Atribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor(named: "Color30") ?? "system green"]
        if segmentControl.selectedSegmentIndex == 0 {
            segmentControl.selectedSegmentTintColor = UIColor(named: "Segment0")
            segmentControl.setTitleTextAttributes(selected0Atribute, for: .selected)
        } else {
            segmentControl.selectedSegmentTintColor = UIColor(named: "Segment1")
            segmentControl.setTitleTextAttributes(selected1Atribute, for: .selected)
        }
        
    }
    

}

extension ItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                 for: indexPath) as! ItemTableViewCell
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SubItemViewController()
        let data = itemData[indexPath.row]
        vc.title = "Danh mục con"

        vc.itemData.removeAll()
        vc.itemData.append(data)
        vc.passData = {
            
            self.checkChange = vc.checkChange
            if vc.checkDeleteItem == true {
                self.deleteItem(index: indexPath.row)
            }
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Sửa") { [self] action, view, complete in
            
            self.editItem(index: indexPath.row)
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
                    
                    self.deleteItem(index: indexPath.row)

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

