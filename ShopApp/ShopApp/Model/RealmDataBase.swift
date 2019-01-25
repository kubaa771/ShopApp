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
        
        //try! realm.write {
        //    realm.deleteAll()
        //}
        
        //uncomment to delete whole database

        //self.realm = nil
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
        print(realm.objects(CategorySection.self))
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
    
}
 
