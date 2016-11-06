//
//  PageViewController.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/27/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UIPageViewController as a page view controller.
//  Allows transitioning between display and animation controllers.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController("Display"),
                self.newViewController("Animation")]
    }()
    
    fileprivate func newViewController(_ prefix: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(prefix)ViewController")
        if prefix == "Display" {
            (vc as! DisplayViewController).student = student
        }
        else if prefix == "Animation" {
            (vc as! AnimationViewController).student = student
        }
        return vc
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
