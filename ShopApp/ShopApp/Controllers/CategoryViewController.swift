//
//  CategoryViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import AMPopTip

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, buttonTappedDelegate, UIPopoverPresentationControllerDelegate {
    
    //MARK: - Model
   
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentList = RealmDataBase.shared.getCurrentList()
    var categories = RealmDataBase.shared.getCategories()
    var newCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let alert = UIAlertController(title: "Add new category", message: "Type new category name below", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            textField.placeholder = "Category"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if self.newCategory != "Category", self.newCategory != "", !self.categories.contains(where: {$0.name == self.newCategory}) {
                RealmDataBase.shared.addNewCategory(name: self.newCategory)
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
    
    @objc func textFieldDidChange(textF: UITextField) {
        newCategory = textF.text!
    }
    
    func handlePopover() {
        /*let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverViewController")
        popoverViewController.modalPresentationStyle = .popover
        
        let label = popoverViewController.view.viewWithTag(1) as! UILabel
        let dismissBtn = popoverViewController.view.subviews[1] as! UIButton
        let nextBtn = popoverViewController.view.subviews[2] as! UIButton
        
        label.text = "Test tooltip"
        label.textAlignment = .center
        
        let height = label.heightForWidth(168)
        popoverViewController.preferredContentSize = CGSize(width: 200, height: 150)
        
        let popover = popoverViewController.presentationController as! UIPopoverPresentationController
        popover.sourceView = self.view
        popover.delegate = self
        popover.sourceRect = self.view.bounds
        popover.permittedArrowDirections = [.down, .up]
        
        self.present(popoverViewController, animated: true, completion: nil)*/
        
        let frame: CGRect!
        let rightBarButton = self.navigationItem.rightBarButtonItem
        let buttonView = rightBarButton!.value(forKey: "view") as! UIView
        frame = buttonView.superview?.frame
        //buttonView.superview?.frame = (UIApplication.shared.keyWindow?.frame)!
        PopTipClass.shared.displayPopTipForFirstTime(with: "Add new category!", with: .down, in: view, from: frame)
        
    }
    
}
