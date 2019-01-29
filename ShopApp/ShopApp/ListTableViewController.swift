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
    
    override func viewDidAppear(_ animated: Bool) {
        lists = RealmDataBase.shared.getLists()
        currentList = RealmDataBase.shared.getCurrentList()
        tableView.reloadData()
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
        let currentDate = Date()
        let newList = MyList(date: currentDate, isActive: true)
        RealmDataBase.shared.addNewList(list: newList)
        self.lists = RealmDataBase.shared.getLists()
        self.currentList = RealmDataBase.shared.getCurrentList()
        self.tableView.reloadData()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewListViewController") as! AddNewListViewController
        vc.currentList = newList
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func btnDoneTapped(cell: ListTableViewCell) {
        if cell.model.isActive == true {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
            vc.title = cell.dataLabel.text
            vc.currentList = currentList //pobrac produkty z tej listy
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
            vc.title = cell.dataLabel.text
            vc.isHistory = true
            //wyslac liste a w historylistvc pobrac z niej produkty
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
