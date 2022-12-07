//
//  SystemVariable.swift
//  EasyFinance
//
//  Created by Quang Lan on 07/12/2022.
//

import Foundation
import UIKit
import RealmSwift
import Charts

public var globeCurrencyShortSymbol: String = ""
public var selectedTabBarItemIndex: Int = 0
public var globeQueryMonth: Date = Date()
let realm = try! Realm()

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

public func getWalletBalance()->(Double,Double,Double,Double) {
    
    var totalOpenBal: Double = 0
    var totalDebit: Double = 0
    var totalCredit: Double = 0
    var totalCurrentBal: Double = 0
    
    let walletData = realm.objects(Wallet.self)
    for wallet in walletData {
        totalOpenBal += wallet.openBal
        totalDebit += wallet.totalDebit
        totalCredit += wallet.totalCredit
        totalCurrentBal += wallet.currentBal
    }
    
    return (totalOpenBal, totalDebit, totalCredit, totalCurrentBal)
}

class ChartViewFormatter: NSObject, AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(format: "%.0f %@", locale: Locale.current, value , globeCurrencyShortSymbol)
    }
    
}
