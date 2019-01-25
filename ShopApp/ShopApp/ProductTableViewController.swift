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
    
    //var productData = [Product(name: "Apple", category: "Fruits", price: 4, urlS: nil, image: UIImage(named: "apple")), Product(name: "Milk", category: "Dairies", price: 2, urlS: nil, image: UIImage(named: "milkk")), Product(name: "Orange", category: "Fruits", price: 5, urlS: nil, image: UIImage(named: "orange"))]
    
    //var food = [CategorySection : [Product]] ()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()
        tableView.delegate = self
        tableView.dataSource = self
        //RealmDataBase.init()

    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       // return CategorySection.Total.rawValue
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let tableSection = CategorySection(rawValue: section), let tableProductData = food[tableSection] {
//            return tableProductData.count
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if let tableSection = CategorySection(rawValue: section), let myData = food[tableSection], myData.count > 0 {
//            return 20
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
//        if let tableSection = CategorySection(rawValue: section) {
//            switch tableSection {
//            case .Fruits:
//                text = CategorySection.Fruits.descripiton
//            case .Dairies:
//                text = CategorySection.Dairies.descripiton
//            case .Meats:
//                text = CategorySection.Meats.descripiton
//            case .Vegetables:
//                text = CategorySection.Vegetables.descripiton
//            default:
//                text = ""
//            }
//        }
//
        return text
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        //cell.model = food[.Fruits]![indexPath.row]
//        if let tableSection = CategorySection(rawValue: indexPath.section), let product = food[tableSection]?[indexPath.row] {
//            cell.model = product
//        }
        
        //print(food[.Fruits][indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let tableSection = CategorySection(rawValue: indexPath.section)
//            //let product = food[tableSection!]?[indexPath.row]
//            food[tableSection!]?.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
    }
    
    //MARK - Sorting Data
    
    func sortData() {
//        food[.Fruits] = productData.filter({ $0.category == "Fruits"})
//        food[.Dairies] = productData.filter({ $0.category == "Dairies"})
//        food[.Meats] = productData.filter({ $0.category == "Meats"})
//        food[.Vegetables] = productData.filter({ $0.category == "Vegetables"})

    }
    
    //MARK - Adding new product
    
    func addNewProduct(product: Product) {
        //productData.append(product)
        sortData()
        tableView.reloadData()
    }
    
    //MARK - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewProduct" {
            let vc: AddProductViewController = segue.destination as! AddProductViewController
            vc.delegate = self
        }
    }
    
    

}

