//
//  Localizable+UIView+Extenstions.swift
//  BonaverdeCoffee
//
//  Created by Tomasz Iwaszek on 17/11/2018.
//  Copyright © 2018 Bonaverde. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var localizedText: String {
        get {
            return self.localizedText
        }
        
        set(text) {
            let lText = NSLocalizedString(text, comment: "")
            switch self {
            case let label as UILabel:
                label.text = lText
            case let textField as UITextField:
                textField.text = lText
            case let button as UIButton:
                button.setTitle(lText, for: .normal)
            default:
                break
            }
        }
    }
    
    /**
     Set this property if you need to localize titles in UISegmentedControl
     */
    @objc var localizedTexts: [String] {
        get {
            return self.localizedTexts
        }
        
        set(texts) {
            switch self {
            case let segmentedControl as UISegmentedControl:
                for (index, text) in texts.enumerated() {
                    let lText = NSLocalizedString(text, comment: "")
                    segmentedControl.setTitle(lText, forSegmentAt: index)
                }
            default:
                break
            }
        }
    }
    
    @IBInspectable var localizedPlaceholderText: String {
        get {
            return self.localizedPlaceholderText
        }
        
        set(text) {
            let lText = NSLocalizedString(text, comment: "")
            switch self {
            case let textField as UITextField:
                textField.placeholder = lText
            default:
                break
            }
        }
    }
}

