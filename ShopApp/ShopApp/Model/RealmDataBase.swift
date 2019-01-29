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
        /*let lists = realm.objects(MyList.self).sorted(byKeyPath: "date", ascending: false)
        for list in lists {
            if list.currentList == true {
                categories = list.currentCategories.sorted(byKeyPath: "sortingID", ascending: true)
            }
        }*/
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
    
    func addNewList(list: MyList) {
        try! realm.write {
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
            list.currentProducts.append(product.name)
        }
    }
    
    func removeProduct(productIndex: Int, fromList list: MyList) {
        try! realm.write {
            list.currentProducts.remove(at: productIndex)
        }
    }
    
    func getProduct(byName name: String) -> Product? {
        let currentProduct = realm.object(ofType: Product.self, forPrimaryKey: name)
        return currentProduct
    }
    
}
 
