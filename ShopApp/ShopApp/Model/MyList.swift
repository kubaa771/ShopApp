//
//  MyList.swift
//  ShopApp
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import RealmSwift

class MyList: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var isActive: Bool = true
    var currentProducts = List<String>()
    var originalProducts = List<String>()
    
    convenience init(date: Date, isActive: Bool){
        self.init()
        self.date = date
        self.isActive = isActive
    }
    
    func containsProduct(productName: String) -> Bool{
        let contains = currentProducts.contains(productName)
        return contains
    }
    

    
    /*override static func primaryKey() -> String? {
     let dateFormatter = DateFormatter()
     let stringKey = dateFormatter.string(from: date)
     return "date"
     }*/
}
