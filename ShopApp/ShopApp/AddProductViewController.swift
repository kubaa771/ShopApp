//
//  AddProductViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var newImage: String?
    var newName: String?
    var newPrice: Int?
    var newCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK - Setting pickerView
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategorySection.Total.rawValue
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CategorySection(rawValue: row)?.descripiton
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newCategory = CategorySection(rawValue: row)?.descripiton
    }
    
    //MARK - Setting textFields
    
    
    @IBAction func addNewNameAction(_ sender: UITextField) {
        newName = sender.text!
    }
    
    
    @IBAction func addNewPriceAction(_ sender: UITextField) {
        newPrice = Int(sender.text!)
    }
    

}
