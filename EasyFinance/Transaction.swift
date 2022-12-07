//
//  Transaction.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import Foundation
import RealmSwift

class Transaction: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var amount: Double
    @Persisted var note: String?
    @Persisted var tranDate: Date
    @Persisted var subItem: SubItem?
    @Persisted var wallet: Wallet?
    @Persisted var imageEvidences: List<ImageEvidence>
    @Persisted var relatedTransactions: List<Transaction>
    var type: String {
        if let strType = subItem?.item?.type {
            return strType
        } else {
            return ""
        }
    }
    convenience init(amount: Double, note: String?, tranDate: Date, subItem: SubItem, wallet: Wallet) {
        self.init()
        self.amount = amount
        self.note = note
        self.tranDate = tranDate
        self.subItem = subItem
        self.wallet = wallet
    }
}
