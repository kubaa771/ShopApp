//
//  Protocols.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

protocol NewProductProtocolDelegate {
    func addNewProduct(product: Product, category: CategorySection)
}

protocol DoneListButtonDelegate {
    func btnDoneTapped(cell: ListTableViewCell)
}

protocol buttonTappedDelegate: AnyObject {
    func btnUPTapped(cell: CategoryTableViewCell)
    func btnDOWNTapped(cell: CategoryTableViewCell)
}
