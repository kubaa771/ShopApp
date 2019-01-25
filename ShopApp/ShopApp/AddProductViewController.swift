//
//  AddProductViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CropViewController

class AddProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    //MARK - Model

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var addCategory: UITextField!
    
    var pickerView = UIPickerView()
    
    var imagePicker: UIImagePickerController!
    
    var newImage: UIImage?
    var newName: String?
    var newPrice: Int?
    var newCategory: String?
    
    var delegate: NewProductProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        addCategory.inputView = pickerView
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //MARK - Setting pickerView
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return CategorySection.Total.rawValue
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return CategorySection(rawValue: row)?.descripiton
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        addCategory.text = CategorySection(rawValue: row)?.descripiton
//        newCategory = CategorySection(rawValue: row)?.descripiton
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
        selectImageFrom(.photoLibrary)
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
//        if newName != "", newPrice != nil {
//            let newProduct = Product(name: newName ?? "", category: newCategory ?? "Fruits", price: newPrice ?? 0, urlS: nil, image: newImage ?? nil)
//            delegate?.addNewProduct(product: newProduct)
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            let alert = UIAlertController.init(title: "Alert", message: "Please fulfill all the fields!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            present(alert, animated: true)
//        }
    }
    
}

extension AddProductViewController: UIImagePickerControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        cropImage(image: selectedImage)
    }
    
    func cropImage (image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        newImage = image
        addImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
}

enum ImageSource {
    case photoLibrary
    case camera
}
