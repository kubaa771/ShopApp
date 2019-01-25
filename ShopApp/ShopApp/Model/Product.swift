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
    @objc dynamic var price: Int = 0
    @objc dynamic var id: String = ""
    
    //var image: String
    
    //@objc dynamic var image: UIImage!
    @objc dynamic var imageData: NSData!
    
    convenience init(name: String, category: CategorySection, price: Int, urlS: String?, image: UIImage?) {
        self.init()
        self.name = name
        self.category = category
        self.price = price
    
        
        if let urlS = urlS, let url = URL(string: urlS) {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .highPriority, progress: { (_, _, url) in
            }) { (downloadedImage, _, _, _) in
                if let downloaded = downloadedImage {
                    let data = NSData(data: downloaded.jpegData(compressionQuality: 0.9)!)
                    self.imageData = data
                    print(data)
                    //self.image = downloaded
                }
            }
        }
        
        if let image = image {
            let data = NSData(data: image.jpegData(compressionQuality: 0.9)!)
            self.imageData = data
            //self.image = image
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
