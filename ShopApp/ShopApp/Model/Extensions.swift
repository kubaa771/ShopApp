//
//  Extensions.swift
//  ShopApp
//
//  Created by user on 23/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = UITextField.BorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UILabel {
    func heightForWidth(_ width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
}

final class FirstLaunch {
    
    let userDefaults: UserDefaults = .standard
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init() {
        let key = "com.any-suggestion.FirstLaunch.WasLaunchedBefore"
        let wasLaunchedBefore = userDefaults.bool(forKey: key)
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            userDefaults.set(true, forKey: key)
        }
    }
    
}

class PopTipClass {
    static let shared = PopTipClass()
    
    func displayPopTipForFirstTime(with text: String, with direction: PopTipDirection , in view: UIView, from rect: CGRect) {
        //let firstLaunch = FirstLaunch()
        //if firstLaunch.isFirstLaunch {
            let popTip = PopTip()
            popTip.show(text: text, direction: direction, maxWidth: 200, in: view, from: rect)
            UIApplication.shared.keyWindow?.addSubview(popTip)
        //}
    }
}
