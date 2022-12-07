//
//  File.swift
//  EasyFinance
//
//  Created by Quang Lan on 22/11/2022.
//

import Foundation
import RealmSwift

class Currency: Object {
    
    @Persisted var country: String
    @Persisted var name: String
    @Persisted var symbol: String
    @Persisted var shortSymbol: String
    @Persisted var flagName: String
    @Persisted var selected: Bool = false
    
    convenience init(country: String, name: String, symbol: String, shortSymbol: String, flagName: String) {
        self.init()
        self.country = country
        self.name = name
        self.symbol = symbol
        self.shortSymbol = shortSymbol
        self.flagName = flagName
    }
}
