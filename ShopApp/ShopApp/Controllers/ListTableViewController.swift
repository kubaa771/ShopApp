//
//  ListTableViewController.swift
//  ShopApp
//
//  Created by user on 22/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DoneListButtonDelegate {
    
    //MARK: - Model
   
    @IBOutlet weak var tableView: UITableView!
    
    var lists = RealmDataBase.shared.getLists()
    var currentList = RealmDataBase.shared.getCurrentList()
    var listsSortedSection = [TableSection: [MyList]]()
    
    func sortListsToSections() {
        lists = RealmDataBase.shared.getLists()
        currentList = RealmDataBase.shared.getCurrentList()
        listsSortedSection[.Active] = lists.filter {$0.isActive == true}
        listsSortedSection[.History] = lists.filter {$0.isActive == false}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Lists", comment: "")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopover), name: NotificationNames.handlePopoverSecond.notification, object: nil)
        sortListsToSections()
        tableView.reloadData()
    }
    
    
    @objc func handlePopover() {
        let rightBarButton = self.navigationItem.rightBarButtonItem
        let buttonView = rightBarButton!.value(forKey: "view") as! UIView
        PopoverManager.shared.handlePopover(viewController: self, view: buttonView, labelText: NSLocalizedString("After you are done adding new products and categories, here you can create new shopping list and add these to the list!", comment: ""))
    }
    
    enum TableSection: Int {
        case Active = 0, History
    }
    
    //MARK: - TableView Settings
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section), let data = listsSortedSection[tableSection], data.count > 0 {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text = ""
        if let tableSection = TableSection(rawValue: section){
            switch tableSection {
            case .Active:
                text = NSLocalizedString("Active", comment: "")
            case .History:
                text = NSLocalizedString("History", comment: "")
            }
        }
        
        return text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        if let tableSection = TableSection(rawValue: indexPath.section), let data = listsSortedSection[tableSection]?[indexPath.row] {
            cell.model = data
        }
        //cell.model = lists[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let tableSection = TableSection(rawValue: indexPath.section), let data = listsSortedSection[tableSection]?[indexPath.row] {
                let listToDelete = data
                RealmDataBase.shared.delete(list: listToDelete)
            }
            
            sortListsToSections()
            self.tableView?.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView?.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        if let tableSection = TableSection(rawValue: indexPath.section), let data = listsSortedSection[tableSection]?[indexPath.row] {
            if data.isActive == true {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
                vc.title = cell.dataLabel.text
                vc.currentList = cell.model
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
                vc.title = cell.dataLabel.text
                vc.isHistory = true
                vc.currentList = cell.model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK - Creating new list
    
    @IBAction func createNewList(_ sender: UIBarButtonItem) {
        let currentDate = Date()
        let newList = MyList(date: currentDate, isActive: true, summary: 0.0)
        RealmDataBase.shared.addNewList(list: newList)
        self.lists = RealmDataBase.shared.getLists()
        self.currentList = RealmDataBase.shared.getCurrentList()
        self.tableView.reloadData()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewListViewController") as! AddNewListViewController
        vc.currentList = newList
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK - Handling tapping at done button
    
    func btnDoneTapped(cell: ListTableViewCell) {
        if cell.model.isActive == true {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
            vc.title = cell.dataLabel.text
            vc.currentList = cell.model
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCurrentListViewController") as! EditCurrentListViewController
            vc.title = cell.dataLabel.text
            vc.isHistory = true
            vc.currentList = cell.model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func backupButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: NSLocalizedString("Create or download backup", comment: ""), message: NSLocalizedString("Choose if u want to create new backup or if you want to download one. Be careful, downloading a backup will delete your current objects.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: ""), style: .default, handler: { (action) in
            RealmDataBase.shared.createBackupFilePath()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Download", comment: ""), style: .default, handler: { (action) in
            RealmDataBase.shared.backupGetStoredData()
            self.sortListsToSections()
            self.tableView.reloadData()
            
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}
