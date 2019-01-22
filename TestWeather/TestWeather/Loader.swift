//
//  Loader.swift
//  TestWeather
//
//  Created by user on 16/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class Loader {
    static var counter = 0
    static var loaderView: UIView?
    
    static func start(){
        counter += 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loaderView = UIView.init(frame: UIScreen.main.bounds)
        loaderView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballClipRotateMultiple, color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), padding: nil)
        loaderView!.addSubview(loader)

        loader.translatesAutoresizingMaskIntoConstraints = false
        //loaderView!.addConstraint(NSLayoutConstraint(item: loader, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loaderView!, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
        //loaderView!.addConstraint(NSLayoutConstraint(item: loader, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loaderView!, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0))
        let hc = loaderView!.centerXAnchor.constraint(equalTo: loader.centerXAnchor)
        let vc = loaderView!.centerYAnchor.constraint(equalTo: loader.centerYAnchor)
        NSLayoutConstraint.activate([hc, vc])
        
        
        loader.startAnimating()
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(loaderView!)
        }
        
    }
    
    static func stop() {
        counter -= 1
        if counter == 0 {
            DispatchQueue.main.async {
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
                loaderView!.removeFromSuperview()
            }
        } else if counter < 0 {
            counter = 0
        }
        
    }
    
}
