//
//  EditCurrentListViewController.swift
//  ShopApp
//
//  Created by user on 28/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class EditCurrentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK: - Model
    
    var currentList: MyList!
    var categoriesWithProductsDict: [CategorySection:[Product]] = [:]
    var sortedKeys = [CategorySection]()
    var isHistory: Bool = false
    var animationEnded = true
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonView: FloatingButtonViewClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(listChangedNotification), name: NotificationNames.listChanged.notification, object: nil)
        convertData()
        replaceButtonName()
        startAnimatingButton()
        buttonView.layer.cornerRadius = 30
        buttonView.tappedClosure = addButtonActionClosure
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - NotificationCenter action
    
    @objc func listChangedNotification() {
        convertData()
    }
    
    //MARK: - Button Animation
    
    func startAnimatingButton() {
        if animationEnded  && isHistory == false {
            animationEnded = false
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (Timer) in
                self.bottomSpacingConstraint.constant = -110
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.animationEnded = true
                })
            }
            bottomSpacingConstraint.constant = 10
            
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func addButtonActionClosure() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewListViewController") as! AddNewListViewController
        vc.currentList = currentList
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func replaceButtonName() {
        if isHistory {
            doneButton.title = "❐"
        } else {
            doneButton.title = "Done"
        }
    }
    
    func convertData() {
        categoriesWithProductsDict.removeAll()
        if let currentProducts = currentList?.currentProducts {
            for productName in currentProducts {
                if let productObj = RealmDataBase.shared.getProduct(byName: productName) {
                    if let productCat = productObj.category {
                        var categoryProductsArray = categoriesWithProductsDict[productCat] ?? []
                        categoryProductsArray.append(productObj)
                        categoriesWithProductsDict[productCat] = categoryProductsArray
                    }
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        let keySection = sortedKeys[section]
        text = keySection.name
        
        return text
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = #colorLiteral(red: 0.7346123007, green: 0.8870626161, blue: 1, alpha: 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let keySection = sortedKeys[indexPath.section]
        let product = categoriesWithProductsDict[keySection]![indexPath.row]
        cell.model = product
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && isHistory == false{
            let keySection = sortedKeys[indexPath.section]
            let productsFromCategory = categoriesWithProductsDict[keySection]
            let product = categoriesWithProductsDict[keySection]![indexPath.row]
            tableView.performBatchUpdates({
                RealmDataBase.shared.removeProduct(productName: product.name, fromList: currentList)
                convertData()
                if indexPath.row == 0, productsFromCategory!.count < 2{
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .automatic)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: nil)
        }
    }
    
    //MARK: - Starting animations
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        startAnimatingButton()
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        if isHistory {
            let duplicateList = RealmDataBase.shared.duplicate(list: currentList)
            RealmDataBase.shared.addNewList(list: duplicateList)
        } else {
            RealmDataBase.shared.editList(list: currentList)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
