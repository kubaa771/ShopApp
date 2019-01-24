//
//  CategoryViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [CategorySection?] ()
    var newCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in CategorySection.allCases {
            categories.append(item)
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.isEditing = true
        // Do any additional setup after loading the view.
    }
    
    //MARK - Configuring TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategorySection.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        if let categoryCell = categories[indexPath.row] {//CategorySection(rawValue: indexPath.row) {
            cell.model = categoryCell.descripiton
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = CategorySection(rawValue: sourceIndexPath.row)
        categories.remove(at: sourceIndexPath.row)
        categories.insert(movedObject!, at: destinationIndexPath.row)
        
    }
    
    
    @IBAction func displayAlertAction(_ sender: UIBarButtonItem) {
        displayAlertWithTextField()
    }
    
    func displayAlertWithTextField() {
        let alert = UIAlertController(title: "Add", message: "Do you want to add new category?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Category"
            self.newCategory = textField.text
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            //Dodanie stringa do enuma?
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
