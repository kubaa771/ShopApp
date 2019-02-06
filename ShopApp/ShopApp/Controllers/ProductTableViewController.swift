//
//  ProductTableViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import RealmSwift

class ProductTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewProductProtocolDelegate {
    
    //MARK - Model
    
    var categories = RealmDataBase.shared.getCategories()
    var currentList = RealmDataBase.shared.getCurrentList()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Products", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = editButtonItem
        //RealmDataBase.init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopover), name: NotificationNames.handlePopoverFirst.notification, object: nil)
        if PopoverManager.shared.iterator == 1 {
            PopoverManager.shared.handlerBlock(true)
        }
        currentList = RealmDataBase.shared.getCurrentList()
        categories = RealmDataBase.shared.getCategories()
        tableView.reloadData()
        
    }
    
    @objc func handlePopover() {
        let rightBarButton = self.navigationItem.rightBarButtonItem
        let buttonView = rightBarButton!.value(forKey: "view") as! UIView
        PopoverManager.shared.handlePopover(viewController: self, view: buttonView, labelText: NSLocalizedString("Here you can add some new products with the categories you created earlier!", comment: ""))
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.visibleCells.isEmpty {
            tableView.setEmptyView(title: NSLocalizedString("You don't have any products", comment: ""), message: NSLocalizedString("You should add some! Tap at the right top button to do that!", comment: ""))
        } else {
            tableView.restore()
        }
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = categories[section]
        let tableProductData = tableSection.products
        return tableProductData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let tableSection = categories[section]
        let tableProductData = tableSection.products
        if tableProductData.count > 0 {
            return 25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        let tableSection = categories[section]
        text = tableSection.name
       
        return text
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = #colorLiteral(red: 0.7346123007, green: 0.8870626161, blue: 1, alpha: 1)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let tableSection = categories[indexPath.section]
        let product = tableSection.products[indexPath.row]
        cell.model = product
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tableSection = categories[indexPath.section]
            let product = tableSection.products[indexPath.row]
            RealmDataBase.shared.deleteProduct(product: product)
            self.tableView?.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableSection = categories[indexPath.section]
        let product = tableSection.products[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProductViewController") as! EditProductViewController
        vc.currentProduct = product
        vc.currentImage = UIImage(data: product.imageData as Data)
        vc.currentImageData = product.imageData
        vc.currentName = product.name
        vc.currentPrice = product.price
        vc.currentCategory = product.category
        vc.oldCategory = product.category
        vc.productIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Adding new product
    
    func addNewProduct(product: Product, category: CategorySection) {
        RealmDataBase.shared.addNewProduct(product: product, category: category)
        tableView.reloadData()
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewProduct" {
            if categories.isEmpty {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You should add some categories first!", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true)
            } else {
                let vc: AddProductViewController = segue.destination as! AddProductViewController
                vc.delegate = self
            }
        }
    }
    
    

}

