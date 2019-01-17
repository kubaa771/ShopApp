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
    
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.lastIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        if nextIndex >= 2 {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
