//
//  NotificationNames.swift
//  TestWeather
//
//  Created by user on 17/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

enum NotificationNames: String{
    
    case unboardingFinish = "unboardingFinish"
    case deepLinkHandler = "deepLinkHandler"
    
    var notification: Notification.Name {
        return Notification.Name(self.rawValue)
    }
    
}
