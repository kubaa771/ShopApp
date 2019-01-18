//
//  City.swift
//  TestWeather
//
//  Created by user on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import SwiftyJSON
struct City {
    let name: String
    let id: Int
    let image: String
    let description: String
    var isExpanded: Bool = false
    
    init(json:JSON) {
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
        self.image = json["image"].stringValue
        self.description = json["description"].stringValue
    }
    
}
