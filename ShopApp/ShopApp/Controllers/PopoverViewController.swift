//
//  PopoverViewController.swift
//  ShopApp
//
//  Created by user on 31/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverViewController")
        popoverViewController.modalPresentationStyle = .popover
        
        let label = popoverViewController.view.viewWithTag(1) as! UILabel
        let dismissBtn = popoverViewController.view.subviews[1] as! UIButton
        let nextBtn = popoverViewController.view.subviews[2] as! UIButton
        
        label.text = "Test tooltip"
        label.textAlignment = .center
        
        let height = label.heightForWidth(168)
        popoverViewController.preferredContentSize = CGSize(width: 200, height: height+60)
        
        if let popover = popoverViewController.popoverPresentationController {
            popover.delegate = self
            popover.permittedArrowDirections = [.down, .up]
            popover.sourceView = self.view
            popover.sourceRect = self.view.bounds
        }
        
        self.present(popoverViewController, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
