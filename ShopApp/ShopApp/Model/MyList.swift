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
    
    convenience init(date: Date, isActive: Bool, summary: Double){
        self.init()
        self.date = date
        self.isActive = isActive
    }
    
    func containsProduct(productId: String) -> Bool{
        let contains = currentProducts.contains(productId)
        return contains
    }
    
    func sumUp() -> Double{
        var sum = 0.0
        for productUUID in currentProducts {
            if let product = RealmDataBase.shared.getProduct(byId: productUUID) {
                sum += product.price
            }
        }
        return sum
    }
    
}
