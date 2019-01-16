//
//  Extensions.swift
//  TestWeather
//
//  Created by user on 16/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(errorMessage: String, tryAgainClosure:@escaping ()->()) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: { (action) in
            tryAgainClosure()
        }))
        present(alert, animated: true)
    }
}
