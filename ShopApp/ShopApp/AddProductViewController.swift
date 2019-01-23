//
//  AddProductViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var imagePicker: UIImagePickerController!
    
    var newImage: String?
    var newName: String?
    var newPrice: Int?
    var newCategory: String?
    
    var delegate: NewProductProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        if sender.isEditing {
            newName = sender.text!
        }
    }
    
    
    @IBAction func addNewPriceAction(_ sender: UITextField) {
        newPrice = Int(sender.text!)
        if sender.isEditing {
            newPrice = Int(sender.text!)
        }
    }
    
    
    
    @IBAction func addNewPhotoAction(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        if newName != "", newPrice != nil {
            let newProduct = Product(name: newName ?? "", category: newCategory ?? "Fruits", price: newPrice ?? 0, image: newImage ?? "")
            delegate?.addNewProduct(product: newProduct)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController.init(title: "Alert", message: "Please fulfill all the fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
}

extension AddProductViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        addImage.image = selectedImage
        newImage = selectedImage.toString()
    }
}

enum ImageSource {
    case photoLibrary
    case camera
}
