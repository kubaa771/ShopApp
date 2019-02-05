//
//  Backups.swift
//  ShopApp
//
//  Created by user on 05/02/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Backups: Object {
    @objc dynamic var uuid = UUID().uuidString
    
    convenience init(id: String) {
        self.init()
        self.uuid = id
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
