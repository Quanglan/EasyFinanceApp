//
//  ItemSearchViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 26/11/2022.
//

import UIKit
import RealmSwift

class ItemSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var subItemData: [SubItem] = []
    var selectedIndex: Int = 0
    var passData: (()-> Void)?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemListCell.nib(), forCellReuseIdentifier: ItemListCell.identifier)
        tableView.estimatedRowHeight = 60
        tableView.sectionHeaderHeight = 60
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        getAllData()

        searchBar.becomeFirstResponder()
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func getAllData() {
        let subItems = realm.objects(SubItem.self)
        subItemData.removeAll()
        subItemData.append(contentsOf: subItems)
        tableView.reloadData()
    }
    
    func searchItem() {
        let query = searchBar.text
        if query == nil || query == "" {
            getAllData()
        } else {

            let subItemQuery = realm.objects(SubItem.self).where { subItem in
                subItem.name.contains(query!, options: .caseInsensitive)
            }
            subItemData.removeAll()
            subItemData.append(contentsOf: subItemQuery)
            tableView.reloadData()
        }
    }
}

extension ItemSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subItemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemListCell.identifier, for: indexPath) as! ItemListCell
        let data = subItemData[indexPath.row]
        cell.setData(imageName: data.iconName,
                     colorName: data.colorName,
                     title: data.name)
        
//        cell.checkSelected(selected: data.selected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
}

extension ItemSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItem()
    }
 
}
