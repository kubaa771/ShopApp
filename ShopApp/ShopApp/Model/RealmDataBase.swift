//
//  RealmDataBase.swift
//  ShopApp
//
//  Created by user on 25/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataBase {
    static let shared = RealmDataBase()
    var realm: Realm!
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("RealmDataBase")
        Realm.Configuration.defaultConfiguration = config
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        self.realm = try! Realm()
        /*try! realm.write {
            realm.deleteAll()
        }
        
        //uncomment to delete whole database

        self.realm = nil*/
    }
    
    func addNewCategory(name: String) {
        let categories = realm.objects(CategorySection.self).sorted(byKeyPath: "sortingID", ascending: true)
        let lastSortingId = categories.last?.sortingID
        var newCategory: CategorySection
        if lastSortingId == nil {
            newCategory = CategorySection(name: name, sortingID: 0)
        } else {
            newCategory = CategorySection(name: name, sortingID: lastSortingId!+1)
        }
        try! realm.write {
            realm.add(newCategory)
        }
    }
    
    func getCategories() -> Results<CategorySection> {
        let categories = realm.objects(CategorySection.self).sorted(byKeyPath: "sortingID", ascending: true)
        return categories
    }
    
    func setSortingIDs(first: CategorySection, second: CategorySection) {
        let sourceSortinId = first.sortingID
        try! realm.write {
            first.sortingID = second.sortingID
            second.sortingID = sourceSortinId
        }
    }
    
    func deleteCategory(category: CategorySection) {
        let products = getProducts()
        for product in products {
            if product.category == category {
                deleteProduct(product: product)
            }
        }
        try! realm.write {
            realm.delete(category)
        }
    }
    
    func addNewProduct(product: Product, category: CategorySection) {
        try! realm.write {
            realm.add(product)
            category.products.append(product)
        }
    }
    
    func getProducts() -> Results<Product> {
        let products = realm.objects(Product.self)
        return products
    }
    
    func deleteProduct(product: Product) {
        let lists = getLists()
        try! realm.write {
            for list in lists {
                if list.containsProduct(productId: product.uuid) {
                    if let index = list.currentProducts.index(of: product.uuid) {
                        list.currentProducts.remove(at: index)
                    }
                }
            }
            realm.delete(product)
        }
    }
    
    func edit(product: Product, name: String, newPrice: Double, oldPrice: Double, categoryToAdd: CategorySection, categoryToDelete: CategorySection, imageData: NSData?) {
        try! realm.write {
            let index = categoryToDelete.products.index(of: product)
            categoryToDelete.products.remove(at: index!)
            product.name = name
            product.price = newPrice
            product.category = categoryToAdd
            product.imageData = imageData
            categoryToAdd.products.append(product)
        }
    }
    
    func addNewList(list: MyList) {
        try! realm.write {
            list.isActive = true
            realm.add(list)
        }
    }
    
    func getCurrentList() -> MyList? {
        let lists = realm.objects(MyList.self)
        var currentList: MyList?
        for list in lists {
            if list.isActive == true {
                currentList = list
            }
        }
        return currentList
        
    }
    
    func getLists() -> Results<MyList> {
        let lists = realm.objects(MyList.self).sorted(byKeyPath: "date", ascending: false)
        return lists
    }
    
    func editList(list: MyList) {
        try! realm.write {
            list.isActive = !list.isActive
        }
    }
    
    func addProduct(product: Product, toList list: MyList) {
        try! realm.write {
            list.currentProducts.append(product.uuid)
        }
        NotificationCenter.default.post(name: NotificationNames.listChanged.notification, object: nil)
    }
    
    func removeProduct(productId: String, fromList list: MyList) {
        try! realm.write {
            let productIndex = list.currentProducts.index(of: productId)
            list.currentProducts.remove(at: productIndex!)
        }
        NotificationCenter.default.post(name: NotificationNames.listChanged.notification, object: nil)
    }
    
    func getProduct(byId id: String) -> Product? {
        let currentProduct = realm.object(ofType: Product.self, forPrimaryKey: id)
        return currentProduct
    }
    
    func delete(list: MyList) {
        try! realm.write {
            realm.delete(list)
            
        }
    }
    
    func duplicate(list: MyList) -> MyList{
        var copy: MyList!
        try! realm.write {
            copy = realm.create(MyList.self, value: list, update: false)
        }
        return copy
    }
    
    func createBackupFilePath(){
        let filemanager = FileManager.default
        
        do {
            let containerURL = filemanager.url(forUbiquityContainerIdentifier: nil)
            let realmArchiveURL = containerURL?.appendingPathComponent("RealmDatabase.realm")
            /*let documentDirectory = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("LocalSave")
            if filemanager.fileExists(atPath: fileURL.path) {
                try filemanager.removeItem(at: fileURL)
            }
            try! realm.writeCopy(toFile: fileURL)*/
            if filemanager.fileExists(atPath: (realmArchiveURL?.path)!) {
                try filemanager.removeItem(at: realmArchiveURL!)
            }
            
            try! realm.writeCopy(toFile: realmArchiveURL!)
        } catch {
            print(error)
        }
    }
    
    func backupGetStoredData() {
        let filemanager = FileManager.default
        do {
            try! realm.write {
                realm.deleteAll()
            }
            self.realm = nil
            let containerURL = filemanager.url(forUbiquityContainerIdentifier: nil)
            let realmArchiveURL = containerURL?.appendingPathComponent("RealmDatabase.realm")
            /*let documentDirectory = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("LocalSave")*/
            if filemanager.fileExists(atPath: (realmArchiveURL?.path)!) {
                var config = Realm.Configuration()
                config.fileURL = realmArchiveURL!
                Realm.Configuration.defaultConfiguration = config
                Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
                self.realm = try! Realm()
            }
            //config.fileURL = fileURL
           
            
        } catch {
            print(error)
        }
        //realm.cancelWrite()
    }
    
}
 
