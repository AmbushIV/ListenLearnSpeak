//
//  WelcomeVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 08/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(true, forKey: "welcoms123")
        
    }

    @IBAction func welcomeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
