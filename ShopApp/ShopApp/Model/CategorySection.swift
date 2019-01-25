//
//  CategorySection.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import RealmSwift


class CategorySection: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var sortingID: Int = 0
    
    let products = List<Product>()
    
    convenience init(name: String, sortingID: Int) {
        self.init()
        self.name = name
        self.sortingID = sortingID
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
