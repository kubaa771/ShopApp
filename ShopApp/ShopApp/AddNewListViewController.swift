//
//  AddNewListViewController.swift
//  ShopApp
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AddNewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK - Model
    
    var categories = RealmDataBase.shared.getCategories()
    var currentList: MyList!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //RealmDataBase.init()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //products = RealmDataBase.shared.getProducts()
        currentList = RealmDataBase.shared.getCurrentList()
        categories = RealmDataBase.shared.getCategories()
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        if currentList.containsProduct(productName: product.name) {
            cell.selectedLabel.text = "✓"
        } else {
            cell.selectedLabel.text = ""
        }
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let tableSection = categories[indexPath.section]
        let product = tableSection.products[indexPath.row]
        if currentList.containsProduct(productName: product.name) {
            RealmDataBase.shared.removeProduct(productIndex: indexPath.row, fromList: currentList)
        } else if cell.selectedLabel.text == "" {
            RealmDataBase.shared.addProduct(product: product, toList: currentList)
        }
        tableView.reloadData()
        
    }
    
    
}

