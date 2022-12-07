//
//  Wallet.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import Foundation
import RealmSwift


//let realm = try! Realm()

class Wallet: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var note: String
    @Persisted var colorName: String
    @Persisted var openBal: Double
    @Persisted var transactions = LinkingObjects(fromType: Transaction.self, property: "wallet")
    
    var totalCredit: Double {
        var sumCredit: Double = 0
        for trans in transactions {
            if trans.type == "income" {
                sumCredit += trans.amount
            }
        }
        return sumCredit
    }
    var totalDebit: Double {
        var sumDebit: Double = 0
        for trans in transactions {
            if trans.type == "spend" {
                sumDebit += trans.amount
            }
        }
        return sumDebit
    }
    var currentBal: Double {
        return openBal + totalCredit - totalDebit
    }

    convenience init(name: String, note: String, colorName: String, openBal: Double) {
        self.init()
        self.name = name
        self.note = note
        self.colorName = colorName
        self.openBal = openBal
    }
}
