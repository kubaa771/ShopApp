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
    @objc dynamic var currentList: Bool = true
    let currentCategories = List<CategorySection>()
    
    convenience init(date: Date, currentList: Bool){
        self.init()
        self.date = date
        self.currentList = currentList
    }
    
    /*override static func primaryKey() -> String? {
     let dateFormatter = DateFormatter()
     let stringKey = dateFormatter.string(from: date)
     return "date"
     }*/
}
