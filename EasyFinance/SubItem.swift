//
//  SubItem.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import Foundation
import RealmSwift

class SubItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var iconName: String
    @Persisted var colorName: String
    @Persisted var budget: Double = 0
    @Persisted var item: Item?
    @Persisted var transactions = LinkingObjects(fromType: Transaction.self, property: "subItem")
    var amount: Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        var sum: Double = 0
        let tranList = transactions.filter { tran in
            formatter.string(from: tran.tranDate ) == formatter.string(from: globeQueryMonth )
        }
        for tran in tranList {
            
            sum += tran.amount
        }
        return sum
    }

    convenience init(name: String, iconName: String, colorName: String, item: Item) {
        self.init()
        self.name = name
        self.iconName = iconName
        self.colorName = colorName
        self.item = item
    }
}
