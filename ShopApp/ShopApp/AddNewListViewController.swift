//
//  AddNewListViewController.swift
//  ShopApp
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AddNewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    //MARK - Model
    
    var categories = RealmDataBase.shared.getCategories()
    var allProducts = RealmDataBase.shared.getProducts()
    var filteredProducts = [Product]()
    var currentList: MyList!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.delegate = self
        tableView.dataSource = self
        //RealmDataBase.init()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return 1
        } else {
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = categories[section]
        let tableProductData = tableSection.products
        if isFiltering() {
            return filteredProducts.count
        }
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
        if isFiltering() {
            return ""
        }
        
        return text
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let tableSection = categories[indexPath.section]
        let product: Product
        if isFiltering() {
            product = filteredProducts[indexPath.row]
        } else {
            product = tableSection.products[indexPath.row]
        }
        cell.model = product
        if currentList.containsProduct(productName: product.name) {
            cell.checkedImageView.isHidden = false
        } else {
            cell.checkedImageView.isHidden = true
        }
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let tableSection = categories[indexPath.section]
        let product: Product
        if isFiltering() {
            product = filteredProducts[indexPath.row]
        } else {
            product = tableSection.products[indexPath.row]
        }
        if currentList.containsProduct(productName: product.name) {
            RealmDataBase.shared.removeProduct(productName: product.name , fromList: currentList)
        } else {
            RealmDataBase.shared.addProduct(product: product, toList: currentList)
        }
        tableView.reloadData()
        
    }
    
    
    //MARK - Searchbar settings
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProducts = allProducts.filter({( product : Product) -> Bool in
            return product.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
}

