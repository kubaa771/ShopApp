//
//  Product.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import RealmSwift

class Product: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var category: CategorySection?
    @objc dynamic var price: Double = 0.0
    @objc dynamic var uuid = UUID().uuidString
    
    @objc dynamic var imageData: NSData!
    
    convenience init(name: String, category: CategorySection, price: Double, urlS: String?, image: UIImage?, id: String) {
        self.init()
        self.name = name
        self.category = category
        self.price = price
        self.uuid = id
        
        if let image = image {
            let data = NSData(data: image.jpegData(compressionQuality: 0.9)!)
            self.imageData = data
        }
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
