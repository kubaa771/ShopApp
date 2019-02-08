//
//  EditProductViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CropViewController

class EditProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - Model
    
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var addCategory: UITextField!
    
    var pickerView = UIPickerView()
    var categories = RealmDataBase.shared.getCategories()
    
    var imagePicker: UIImagePickerController!
    
    var defaultImage = UIImage(named: "shop")
    var currentProduct: Product!
    var currentImage: UIImage?
    var currentImageData: NSData?
    var currentName: String!
    var currentPrice: Double!
    var oldCategory: CategorySection!
    var oldPrice: Double!
    var currentCategory: CategorySection?
    var productIndex: Int!
    
    var delegate: NewProductProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFieldsWithCurrentInfo()
        addName.setBottomBorder()
        addPrice.setBottomBorder()
        addCategory.setBottomBorder()
        addName.delegate = self
        addPrice.delegate = self
        addCategory.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        addCategory.inputView = pickerView
        setAccessoryView(textField: addCategory)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupFieldsWithCurrentInfo() {
        addName.text = currentName
        addPrice.text = String(currentPrice)
        addCategory.text = currentCategory?.name
        if currentImage != nil{
            addImage.image = currentImage
        }
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
        currentCategory = categories[row]
    }
    
    
    //MARK: - Setting TextFields
    
    @IBAction func addNewNameAction(_ sender: UITextField) {
        currentName = sender.text!
        if sender.isEditing {
            currentName = sender.text!
        }
    }
    
    
    @IBAction func addNewPriceAction(_ sender: UITextField) {
        currentPrice = Double(sender.text!)
        if sender.isEditing {
            currentPrice = Double(sender.text!)
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
        currentCategory = categories[0]
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
        RealmDataBase.shared.edit(product: currentProduct, name: currentName, newPrice: currentPrice, oldPrice: oldPrice, categoryToAdd: currentCategory!, categoryToDelete: oldCategory, imageData: currentImageData)
        navigationController?.popViewController(animated: true)
    }
    
}

extension EditProductViewController: UIImagePickerControllerDelegate, CropViewControllerDelegate {
    
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
        currentImage = image
        currentImageData = NSData(data: image.jpegData(compressionQuality: 0.9)!)
        addImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
}

