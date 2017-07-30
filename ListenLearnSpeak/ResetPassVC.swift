//
//  ResetPassVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 19/07/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPassVC: UIViewController {

    @IBOutlet weak var emailResetField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailResetField.text!) { (error) in
            self.goToLogin()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func goToLogin() {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.present(viewController, animated: true, completion: nil)
        
    }
    

}
