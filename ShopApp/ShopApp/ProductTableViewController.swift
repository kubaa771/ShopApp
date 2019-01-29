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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //RealmDataBase.init()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = categories[section]
        //let tableSection = products2DArray[section].1
        let tableProductData = tableSection.products//categoriesWithProductsDict[tableSection]
        return tableProductData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let tableSection = categories[section]
        let tableProductData = tableSection.products
        if tableProductData.count > 0 {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        let tableSection = categories[section]
        text = tableSection.name
       
        return text
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let tableSection = categories[indexPath.section]
        let product = tableSection.products[indexPath.row]
        cell.model = product
        return cell
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
    
    //MARK - Adding new product
    
    func addNewProduct(product: Product, category: CategorySection) {
        RealmDataBase.shared.addNewProduct(product: product, category: category)
        tableView.reloadData()
    }
    
    //MARK - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if categories.isEmpty {
            let alert = UIAlertController(title: "Error", message: "You should add some categories first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        } else if segue.identifier == "createNewProduct" {
            let vc: AddProductViewController = segue.destination as! AddProductViewController
            vc.delegate = self
        }
    }
    
    

}

