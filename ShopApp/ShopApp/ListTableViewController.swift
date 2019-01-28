//
//  ListTableViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DoneListButtonDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var lists = RealmDataBase.shared.getLists()
    var currentList = RealmDataBase.shared.getCurrentList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        cell.model = lists[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    @IBAction func createNewList(_ sender: UIBarButtonItem) {
        if currentList == nil {
            let alert = UIAlertController(title: "Add new list", message: "Do you want to add new list?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                let currentDate = Date()
                RealmDataBase.shared.addNewList(list: MyList(date: currentDate, currentList: true))
                self.lists = RealmDataBase.shared.getLists()
                self.currentList = RealmDataBase.shared.getCurrentList()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "You already have one current list! If u want add a new one, you should finish editing this.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func btnDoneTapped(cell: ListTableViewCell) {
        if cell.model.currentList == true {
            let currentMyList = cell.model
            //if this is current list, end editing
            RealmDataBase.shared.editList(list: currentMyList!)
            lists = RealmDataBase.shared.getLists()
            currentList = nil
            tableView.reloadData()
        } else {
            //view history
        }
    }
    
    
}
