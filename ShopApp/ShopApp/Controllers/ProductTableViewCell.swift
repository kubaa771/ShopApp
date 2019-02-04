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
    
    //MARK: - Model
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    var model: Product! {
        didSet {
            customize(product: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Cell customization
    
    func customize(product: Product) {
        productName.text = product.name
        productPrice.text = String(product.price) + NSLocalizedString("$", comment: "")
        productImage.image = UIImage(data: product.imageData! as Data)
        
    }
}
