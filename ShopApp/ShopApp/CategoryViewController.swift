//
//  CategoryViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, buttonTappedDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var currentList = RealmDataBase.shared.getCurrentList()
    var categories = //RealmDataBase.shared.getCategories()
    var newCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func model() {
        var categories = currentList?.currentCategories
    }
    
    //MARK - Configuring TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let categoryCell = categories[indexPath.row]
        cell.model = categoryCell.name
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryCell = categories[indexPath.row]
            RealmDataBase.shared.deleteCategory(category: categoryCell)
            self.tableView?.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.endUpdates()
            categories = RealmDataBase.shared.getCategories()
        }
    }
    
    //MARK - Handling cell's buttons tapping
    
    func btnUPTapped(cell: CategoryTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let chosenCategory = categories[indexPath!.row]
        let neighbourUpCategory: CategorySection?
        if indexPath!.row != 0 {
            neighbourUpCategory = categories[indexPath!.row - 1]
            RealmDataBase.shared.setSortingIDs(first: chosenCategory, second: neighbourUpCategory!)
            categories = RealmDataBase.shared.getCategories()
            tableView.reloadData()
        }
    }
    
    func btnDOWNTapped(cell: CategoryTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let chosenCategory = categories[indexPath!.row]
        let neighbourDownCategory: CategorySection?
        if categories[indexPath!.row].sortingID != categories.last?.sortingID {
            neighbourDownCategory = categories[indexPath!.row + 1]
            RealmDataBase.shared.setSortingIDs(first: chosenCategory, second: neighbourDownCategory!)
            categories = RealmDataBase.shared.getCategories()
            tableView.reloadData()
        }
    }
    
    //MARK - Displaying alert
    
    @IBAction func displayAlertAction(_ sender: UIBarButtonItem) {
        displayAlertWithTextField()
    }
    
    func displayAlertWithTextField() {
        if currentList == nil {
            let alert = UIAlertController(title: "Error", message: "Add new list first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Add new category", message: "Type new category name below", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
                textField.placeholder = "Category"
            }
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                if self.newCategory != "Category", self.newCategory != "", !self.categories.contains(where: {$0.name == self.newCategory}) {
                    RealmDataBase.shared.addNewCategory(name: self.newCategory, list: self.currentList!)
                } else {
                    let alertIfSomethingWentWrong = UIAlertController(title: "Something went wrong", message: "Probably that category already exist, or you left empty text field. Try Again!", preferredStyle: .alert)
                    alertIfSomethingWentWrong.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    self.present(alertIfSomethingWentWrong, animated: true)
                }
                self.categories = RealmDataBase.shared.getCategories()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc func textFieldDidChange(textF: UITextField) {
        newCategory = textF.text!
    }
    
}
