//
//  AddProductViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CropViewController

class AddProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - Model

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var addCategory: UITextField!
    
    var pickerView = UIPickerView()
    var categories = RealmDataBase.shared.getCategories()
    var products = RealmDataBase.shared.getProducts()
    
    var imagePicker: UIImagePickerController!
    
    var defaultImage = UIImage(named: "shop")
    var newImage: UIImage?
    var newName: String?
    var newPrice: Double?
    var newCategory: CategorySection?
    
    var delegate: NewProductProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addName.delegate = self
        addCategory.delegate = self
        addPrice.delegate = self
        addName.setBottomBorder()
        addPrice.setBottomBorder()
        addCategory.setBottomBorder()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        addCategory.inputView = pickerView
        setAccessoryView(textField: addCategory)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Setting PickerView
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addCategory.text = categories[row].name
        newCategory = categories[row]
    }
    
    
    //MARK: - Setting TextFields
    
    @IBAction func addNewNameAction(_ sender: UITextField) {
        newName = sender.text!
        if sender.isEditing {
            newName = sender.text!
        }
    }
    
    
    @IBAction func addNewPriceAction(_ sender: UITextField) {
        newPrice = Double(sender.text!)
        if sender.isEditing {
            newPrice = Double(sender.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    @IBAction func tappedAction(_ sender: UITextField) {
        addCategory.text = categories[0].name
        newCategory = categories[0]
    }
    
    //MARK: - ImagePicker configuration
    
    @IBAction func addNewPhotoAction(_ sender: UIButton) {
        selectImageFrom(.photoLibrary)
    }
    
    @IBAction func openCameraAction(_ sender: UIButton) {
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
    
    //MARK: - Done, Protocol Segue
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        if newName != nil , newPrice != nil, newCategory != nil, !categories.contains(where: {$0.products.contains(where: {$0.name == newName})}), !products.contains(where: {$0.name == newName}) {
            let newProduct = Product(name: newName ?? "", category: newCategory!, price: newPrice ?? 0.0, urlS: nil, image: newImage ?? defaultImage, id: UUID().uuidString)
            delegate?.addNewProduct(product: newProduct, category: newCategory!)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please check all the fields!", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
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
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioLockEnabled = true
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
