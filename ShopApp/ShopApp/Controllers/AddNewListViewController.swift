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
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK: - Table view data source
    
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
            return 25
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = #colorLiteral(red: 0.7346123007, green: 0.8870626161, blue: 1, alpha: 1)
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
        if currentList.containsProduct(productId: product.uuid) {
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
        if currentList.containsProduct(productId: product.uuid) {
            RealmDataBase.shared.removeProduct(productId: product.uuid , fromList: currentList)
            RealmDataBase.shared.priceSumUp(productPrice: product.price, to: currentList, add: false)
        } else {
            RealmDataBase.shared.addProduct(product: product, toList: currentList)
            RealmDataBase.shared.priceSumUp(productPrice: product.price, to: currentList, add: true)
        }
        tableView.reloadData()
        
    }
    
    
    //MARK: - Searchbar settings
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
       
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setImage(UIImage(named: "search.png"), for: .search, state: .normal)
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if categories.count != 0 && allProducts.count > 0{
        filteredProducts = allProducts.filter({( product : Product) -> Bool in
            return product.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
}

