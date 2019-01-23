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

class Product {
    var name: String
    var category :String
    var price: Int
    
    //var image: String
    
    var image: UIImage!
    
    init(name: String, category: String, price: Int, urlS: String?, image: UIImage?) {
        self.name = name
        self.category = category
        self.price = price
    
        if let urlS = urlS, let url = URL(string: urlS) {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: { (_, _, url) in
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
}
