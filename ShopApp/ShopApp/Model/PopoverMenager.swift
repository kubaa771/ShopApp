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

    func handlePopover(viewController: UIViewController, view: UIView) {
        let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverViewController")
        popoverViewController.modalPresentationStyle = .popover
        
        let label = popoverViewController.view.viewWithTag(1) as! UILabel
        let nextBtn = popoverViewController.view.viewWithTag(2) as! UIButton//subviews[1] as! UIButton
        
        nextBtn.addTarget(self, action: #selector(nextPopover), for: .touchUpInside)
        
        label.text = "Test tooltip"
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
    
    @objc func nextPopover() {
        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductTableViewController")
        //handlePopover()
        
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
