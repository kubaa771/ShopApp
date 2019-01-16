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
    var counter = 0
    var view :UIView!
    static var loaderView: UIView?
    
    static func start(){
        //counter += 1
        loaderView = UIView.init(frame: UIScreen.main.bounds)
        loaderView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballClipRotateMultiple, color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), padding: nil)
        //loader.center = CGPoint(x: UIScreen.main.bounds., y: 150)
        loader.startAnimating()
        
        DispatchQueue.main.async {
            loaderView!.addSubview(loader)
            (UIApplication.shared.delegate?.window??.rootViewController?.view)!.addSubview(loaderView!)
        }

        
    }
    
    static func stop() {
        //counter -= 1
        //if counter <= 0 {
            DispatchQueue.main.async {
                loaderView!.removeFromSuperview()
            }
        //}
    }
    
}
