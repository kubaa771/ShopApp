//
//  PopoverViewController.swift
//  ShopApp
//
//  Created by user on 31/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class PopoverManager: NSObject {
    
    static let shared = PopoverManager()
    weak var currentViewController: UIViewController!
    weak var currentView: UIView!
    var iterator = 0
    var handlerBlock: (Bool) -> Void = { done in
        if done {
            NotificationCenter.default.post(name: NotificationNames.handlePopoverFirst.notification, object: nil)
        }
    }

    func handlePopover(viewController: UIViewController, view: UIView, labelText: String) {
        if iterator <= 2 {
            currentViewController = viewController
            currentView = view
            iterator += 1
            let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverViewController")
            popoverViewController.modalPresentationStyle = .popover
            
            let label = popoverViewController.view.viewWithTag(1) as! UILabel
            let nextBtn = popoverViewController.view.viewWithTag(2) as! UIButton//subviews[1] as! UIButton
            
            nextBtn.addTarget(self, action: #selector(nextPopover), for: .touchUpInside)
            
            label.text = labelText
            label.textAlignment = .center
            
            let height = label.heightForWidth(168)
            popoverViewController.preferredContentSize = CGSize(width: 200, height: height + 80)
            
            let popover = popoverViewController.presentationController as! UIPopoverPresentationController
            popover.sourceView = view//?
            popover.delegate = self
            popover.sourceRect = view.bounds //?
            popover.permittedArrowDirections = [.down, .up]
            
            viewController.present(popoverViewController, animated: true, completion: nil)
        }

    }
    
    
    @objc func nextPopover() {
        currentViewController.dismiss(animated: true, completion: nil)
        if iterator == 1 {
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                
            }
        } else if iterator == 2{
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 2
                NotificationCenter.default.post(name: NotificationNames.handlePopoverSecond.notification, object: nil)
            }
        }
        
        //tabBarController?.selectedIndex = 0
        
    }
    
}

extension PopoverManager: UIPopoverPresentationControllerDelegate  {
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
