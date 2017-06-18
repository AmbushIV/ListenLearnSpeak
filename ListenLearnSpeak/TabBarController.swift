//
//  TabBarController.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 08/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var itemsTBC: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTBC.unselectedItemTintColor = UIColor(white: 1, alpha: 1)

        if UserDefaults.standard.bool(forKey: "welcoms123") {
            //Nimic
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
                self.present(viewController, animated: true, completion: nil)
            })
        }
        
    }

}
