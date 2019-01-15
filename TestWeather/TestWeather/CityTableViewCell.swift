//
//  CityTableViewCell.swift
//  TestWeather
//
//  Created by user on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

protocol buttonTappedDelegate: AnyObject{
    func btnCloseTapped(cell: CityTableViewCell)
}

class CityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDetailButton: UIButton!
    @IBOutlet weak var cityDescription: UITextView!
    
    var model :City! {
        didSet {
            customize(city: model)
        }
    }
    
    
    @IBAction func moreInfoAction(_ sender: UIButton) {
        delegate?.btnCloseTapped(cell: self)
    }
    
    weak var delegate: buttonTappedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(city: City) {
        cityNameLabel.text = city.name
        cityDescription.text = city.description
        cityImage.sd_setImage(with: URL(string: city.image), completed: nil)
        city.isExpanded ? (cityDescription.isHidden = false) : (cityDescription.isHidden = true)
        city.isExpanded ? (cityDetailButton.setTitle("Less Info", for: UIControl.State.normal)) : (cityDetailButton.setTitle("More Info", for: UIControl.State.normal))
    }

}
