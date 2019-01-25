//
//  ProductTableViewCell.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    var model: Product! {
        didSet {
            customize(product: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(product: Product) {
        productName.text = product.name
        productPrice.text = String(product.price) + "$"
        //productImage.image = product.image
        productImage.image = UIImage(data: product.imageData! as Data)
        
    }

}
