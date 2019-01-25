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
    @objc dynamic var category :String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var id: String = ""
    
    //var image: String
    
    @objc dynamic var image: UIImage!
    
    convenience init(name: String, category: String, price: Int, urlS: String?, image: UIImage?) {
        self.init()
        self.name = name
        self.category = category
        self.price = price
    
        if let urlS = urlS, let url = URL(string: urlS) {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .highPriority, progress: { (_, _, url) in
            }) { (downloadedImage, _, _, _) in
                if let downloaded = downloadedImage {
                    self.image = downloaded
                }
            }
        }
        
        if let image = image {
            self.image = image
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
