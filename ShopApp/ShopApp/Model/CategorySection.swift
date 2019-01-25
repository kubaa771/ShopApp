//
//  CategorySection.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import RealmSwift

//enum CategorySection: Int, CaseIterable {
//    case Fruits = 0, Vegetables, Dairies, Meats, Total
//
//    var descripiton: String {
//        switch self {
//        case.Fruits: return "Fruits"
//        case.Dairies: return "Dairies"
//        case.Vegetables: return "Vegetables"
//        case.Meats: return "Meats"
//        default: return ""
//        }
//    }
//
//    init? (id: Int) {
//        switch id {
//        case 1: self = .Fruits
//        case 2: self = .Dairies
//        case 3: self = .Vegetables
//        case 4: self = .Meats
//        default: return nil
//        }
//    }
//}

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
