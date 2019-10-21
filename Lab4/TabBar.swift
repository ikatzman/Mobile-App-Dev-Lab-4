//
//  TabBar.swift
//  Lab4
//
//  Created by Ian Katzman on 10/20/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell our UITabBarController subclass to handle its own delegate methods
        self.delegate = self
    }
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is FirstViewController {
            print("First tab")
        } else if viewController is SecondViewController {
            viewController.viewDidLoad()
        }
    }
}
