//
//  NotificationNames.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

enum NotificationNames: String {
    case applyProduct = "applyProduct"
    
    var notification: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}
