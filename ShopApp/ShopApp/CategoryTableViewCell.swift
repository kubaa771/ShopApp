//
//  CategoryTableViewCell.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

protocol buttonTappedDelegate: AnyObject {
    func btnUPTapped(cell: CategoryTableViewCell)
    func btnDOWNTapped(cell: CategoryTableViewCell)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    weak var delegate: buttonTappedDelegate?
    
    var model: String! {
        didSet {
            customize(category: model)
        }
    }
    
    func customize(category: String) {
        categoryLabel.text = category
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func upButtonAction(_ sender: UIButton) {
        delegate?.btnUPTapped(cell: self)
    }
    
    @IBAction func downButtonAction(_ sender: UIButton) {
        delegate?.btnDOWNTapped(cell: self)
    }
}
