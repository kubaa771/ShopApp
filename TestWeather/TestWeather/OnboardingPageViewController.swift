//
//  OnboardingPageViewController.swift
//  TestWeather
//
//  Created by user on 16/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"\(name)ViewController")
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name: "First"),
                self.newViewController(name: "Second")] as [UIViewController]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward , animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = #colorLiteral(red: 0, green: 0.5075943764, blue: 0.9108930522, alpha: 0.4911146567)
            }
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = orderedViewControllers.lastIndex(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    
}
