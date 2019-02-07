//
//  ListTableViewCell.swift
//  ShopApp
//
//  Created by Jakub Iwaszek on 24/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    //MARK: Model
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    var model: MyList! {
        didSet {
            customize(list: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Button actions, customization
    
    
    func customize(list: MyList) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: list.date)
        let myDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let myDateStringFinal = formatter.string(from: myDate!)
        //if list.currentProducts.count == 0 {
            //dataLabel.text = myDateStringFinal + " | " + String(format: "%.2f", 0.0) + NSLocalizedString("$", comment: "")
       // } else {
            dataLabel.text = myDateStringFinal + " | " + String(format: "%.2f", list.summary) + NSLocalizedString("$", comment: "")
        //}
        
        if list.isActive {
            checkedImageView.isHidden = true
        } else {
            checkedImageView.isHidden = false
        }
    }

}
