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
        try! realm.write {
            realm.delete(product)
        }
    }
    
    func edit(product: Product, name: String, price: Double, categoryToAdd: CategorySection, categoryToDelete: CategorySection, productIndex: Int , imageData: NSData?) {
        try! realm.write {
            categoryToDelete.products.remove(at: productIndex)
            product.name = name
            product.price = price
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
    
    func getLastBackupFilePath(){
        let filemanager = FileManager.default
        do {
            let documentDirectory = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("LocalSave")
            if filemanager.fileExists(atPath: fileURL.path) {
                try filemanager.removeItem(at: fileURL)
            }
            //var key = NSMutableData(length: 64)!
            //SecRandomCopyBytes(kSecRandomDefault, key.length, key)
            try! realm.writeCopy(toFile: fileURL)
        } catch {
            print(error)
        }
        //realm.cancelWrite()
    }
    
    func backupGetStoredData() {
        let filemanager = FileManager.default
        do {
            try! realm.write {
                realm.deleteAll()
            }
            self.realm = nil
            let documentDirectory = try filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent("LocalSave")
            var config = Realm.Configuration()
            config.fileURL = fileURL
            Realm.Configuration.defaultConfiguration = config
            Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
            self.realm = try! Realm()
            
            
        } catch {
            print(error)
        }
        //realm.cancelWrite()
    }
    
}
 
