//
//  File.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import Foundation
import RealmSwift

class ImageEvidence: Object {
    @Persisted var name: String
    @Persisted var linkPath: String

    convenience init(name: String, linkPath: String) {
        self.init()
        self.name = name
        self.linkPath = linkPath
    }
    
}

