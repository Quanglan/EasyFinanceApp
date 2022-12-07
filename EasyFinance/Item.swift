//
//  Item.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var name: String
    @Persisted var iconName: String
    @Persisted var colorName: String
    @Persisted var budget: Double = 0
    @Persisted var type: String // spend, income
    @Persisted var subItems = LinkingObjects(fromType: SubItem.self, property: "item")
    //@Persisted var subItems = List<SubItem>()
    var amount: Double {
        var sum: Double = 0
        for subitem in subItems {
            sum += subitem.amount
        }
        return sum
    }
    convenience init(name: String, iconName: String, colorName: String, type: String) {
        self.init()
        self.name = name
        self.iconName = iconName
        self.colorName = colorName
        self.type = type
    }
    var countSubItem: Int {
        return subItems.count
    }
}
