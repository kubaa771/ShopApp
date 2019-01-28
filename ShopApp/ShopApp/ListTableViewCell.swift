//
//  ListTableViewCell.swift
//  ShopApp
//
//  Created by Jakub Iwaszek on 24/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: DoneListButtonDelegate?
    
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
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        delegate?.btnDoneTapped(cell: self)
        print("Test")
    }
    
    func customize(list: MyList) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: list.date)
        let myDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let myDateStringFinal = formatter.string(from: myDate!)
        dataLabel.text = myDateStringFinal
        if list.currentList {
            doneButton.setTitle("✓", for: .normal)
        } else {
            doneButton.setTitle("✕", for: .normal)
        }
    }

}
