//
//  Extensions.swift
//  TestWeather
//
//  Created by user on 16/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    //MARK - Displaying alert
    
    func displayAlert(errorMessage: String, tryAgainClosure:@escaping ()->()) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: { (action) in
            tryAgainClosure()
        }))
        present(alert, animated: true)
    }
    
    //MARK - Displaying loader
    
    func displayLoader (loader: NVActivityIndicatorView, view: UIView) {
        loader.center = CGPoint(x: view.center.x, y: 150)
        view.addSubview(loader)
        loader.startAnimating()
    }
    
    func hideLoader (loader: NVActivityIndicatorView) {
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}
