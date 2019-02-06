//
//  CategoryViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import AMPopTip

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, buttonTappedDelegate{
    
    //MARK: - Model
   
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentList = RealmDataBase.shared.getCurrentList()
    var categories = RealmDataBase.shared.getCategories()
    var newCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Categories", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentList = RealmDataBase.shared.getCurrentList()
        categories = RealmDataBase.shared.getCategories()
        tableView.reloadData()
        handlePopover()
    }
    
    //MARK: - Configuring TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.count == 0 {
            tableView.setEmptyView(title: NSLocalizedString("You don't have any categories", comment: ""), message: NSLocalizedString("You should add some by tapping at the right top button!", comment: ""))
        } else {
            tableView.restore()
        }
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
    
    //MARK: - Handling cell's buttons tapping
    
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
    
    //MARK: - Displaying alert
    
    @IBAction func displayAlertAction(_ sender: UIBarButtonItem) {
        displayAlertWithTextField()
    }
    
    func displayAlertWithTextField() {
        let alert = UIAlertController(title: NSLocalizedString("Add new category", comment: ""), message: NSLocalizedString("Type new category name below", comment: ""), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            textField.placeholder = NSLocalizedString("Category", comment: "")
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: { (action) in
            if self.newCategory != "Category", self.newCategory != "", !self.categories.contains(where: {$0.name == self.newCategory}) {
                RealmDataBase.shared.addNewCategory(name: self.newCategory)
            } else {
                let alertIfSomethingWentWrong = UIAlertController(title: NSLocalizedString("Something went wrong", comment: ""), message: NSLocalizedString("Probably that category already exist, or you left empty text field. Try Again!", comment: ""), preferredStyle: .alert)
                alertIfSomethingWentWrong.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
                self.present(alertIfSomethingWentWrong, animated: true)
            }
            self.categories = RealmDataBase.shared.getCategories()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true)
        }
    
    @objc func textFieldDidChange(textF: UITextField) {
        newCategory = textF.text!
    }
    
    func handlePopover() {
        let firstLaunch = FirstLaunch()
        if firstLaunch.isFirstLaunch {
            let rightBarButton = self.navigationItem.rightBarButtonItem
            let buttonView = rightBarButton!.value(forKey: "view") as! UIView
            PopoverManager.shared.handlePopover(viewController: self, view: buttonView, labelText: NSLocalizedString("Here you can add some new categories!", comment: ""))
        }
        
        /*let frame: CGRect!
        let rightBarButton = self.navigationItem.rightBarButtonItem
        let buttonView = rightBarButton!.value(forKey: "view") as! UIView
        frame = buttonView.superview?.frame
        //buttonView.superview?.frame = (UIApplication.shared.keyWindow?.frame)!
        PopTipClass.shared.displayPopTipForFirstTime(with: "Add new category!", with: .down, in: view, from: frame)*/
        
    }
    
    
}
