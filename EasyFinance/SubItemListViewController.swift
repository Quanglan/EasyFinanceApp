//
//  SubItemListViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit
import RealmSwift

class SubItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var itemData: [Item] = []
    var subItemData: [SubItem] = []
    var subItemIndex: Int = 0
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
    
}

extension SubItemListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
                         editBtn: false)
            
        } else {
            let data = subItemData[indexPath.row]

            cell.setData(imageName: data.iconName,
                         colorName: data.colorName,
                         title: data.name,
                         budget: data.budget,
                         amount: data.amount,
                         type: itemData[0].type,
                         editBtn: false)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            subItemIndex = indexPath.row
            navigationController?.popViewController(animated: true)
            passData?()
        }
    }
    
}
