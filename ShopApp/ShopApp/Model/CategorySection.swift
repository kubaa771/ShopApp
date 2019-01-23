//
//  CategorySection.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

enum CategorySection: Int {
    case Fruits = 0, Vegetables, Dairies, Meats, Total
    
    var descripiton: String {
        switch self {
        case.Fruits: return "Fruits"
        case.Dairies: return "Dairies"
        case.Vegetables: return "Vegetables"
        case.Meats: return "Meats"
        default: return ""
        }
    }
}
