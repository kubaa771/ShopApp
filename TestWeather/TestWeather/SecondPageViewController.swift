//
//  SecondPageViewController.swift
//  TestWeather
//
//  Created by user on 17/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class SecondPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func segueButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NotificationNames.unboardingFinish.notification, object: nil)
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
