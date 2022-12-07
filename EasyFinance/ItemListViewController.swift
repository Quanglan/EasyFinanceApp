//
//  ItemListViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit
import RealmSwift

class ItemListViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    var itemData: [Item] = []
    var selectedSubItemData: [SubItem] = []
    var type: String = ""
    var itemIndex: Int = 0
//    var subItemIndex: Int = 0
    var passData: (()-> Void)?
    let realm = try! Realm()
    var callModule: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globeQueryMonth = Date()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.nib(), forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.estimatedRowHeight = 60
        tableView.sectionHeaderHeight = 60
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addNewItem))
        
        if callModule != "ChangeItem" {

            navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(showSearchItemList)))
        }
        
        let font = UIFont.systemFont(ofSize: 17)
        let normalAtribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.gray]
        let font0 = UIFont.boldSystemFont(ofSize: 18)
        let selected0Atribute: [NSAttributedString.Key: Any] = [.font: font0, .foregroundColor: UIColor.red]
        
        segmentControl.setTitleTextAttributes(normalAtribute, for: .normal)
        segmentControl.setTitleTextAttributes(selected0Atribute, for: .selected)
        
        getAllData()
        tableView.reloadData()
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showSearchItemList() {
        let vc = ItemSearchViewController()
        vc.title = "Tìm kiếm danh mục"
        vc.passData = {
            self.selectedSubItemData.removeAll()
            self.selectedSubItemData.append(vc.subItemData[vc.selectedIndex])
            self.navigationController?.popViewController(animated: true)
            self.passData?()
        }
        navigationController?.pushViewController(vc, animated: true)
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

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemData.count
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
                     editBtn: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if callModule == "ChangeItem" {
            navigationController?.popViewController(animated: true)
            itemIndex = indexPath.row
            passData?()
        } else {
            let vc = SubItemListViewController()
            let data = itemData[indexPath.row]
            vc.title = "Danh mục con"
            vc.itemData.removeAll()
            vc.itemData.append(data)
            vc.passData = {
//                self.subItemIndex = vc.subItemIndex
//                self.itemIndex = indexPath.row
                self.selectedSubItemData.removeAll()
                self.selectedSubItemData.append(vc.subItemData[vc.subItemIndex])
                self.navigationController?.popViewController(animated: true)
                self.passData?()
            }
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
}
