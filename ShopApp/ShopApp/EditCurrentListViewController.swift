//
//  EditCurrentListViewController.swift
//  ShopApp
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class EditCurrentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK - Model
    
    var currentList: MyList!
    var categoriesWithProductsDict: [CategorySection:[Product]] = [:]
    var sortedKeys = [CategorySection]()
    var isHistory: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertData()
        tableView.delegate = self
        tableView.dataSource = self
        //RealmDataBase.init()
        
    }
    
    func convertData() {
        if let currentProducts = currentList?.currentProducts {
            for productName in currentProducts {
                if let productObj = RealmDataBase.shared.getProduct(byName: productName) {
                    let productCat = productObj.category
                    var categoryProductsArray = categoriesWithProductsDict[productCat!] ?? []
                    categoryProductsArray.append(productObj)
                    categoriesWithProductsDict[productCat!] = categoryProductsArray
                    }
            }
            sortedKeys = categoriesWithProductsDict.keys.sorted { (left, right) -> Bool in
                return left.sortingID < right.sortingID
            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesWithProductsDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keySection = sortedKeys[section]
        let tableProductData = categoriesWithProductsDict[keySection]
        return tableProductData!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        let keySection = sortedKeys[section]
        text = keySection.name
        
        return text
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let keySection = sortedKeys[indexPath.section]
        let product = categoriesWithProductsDict[keySection]![indexPath.row]
        cell.model = product
        return cell
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        RealmDataBase.shared.editList(list: currentList)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
