//
//  LoginVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 05/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if AccessToken.current?.authenticationToken != nil {
            self.goToMap()
        } else {
            print("nelogat prin fb")
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passField.text!) { (user, error) in
            if error == nil {
                self.goToMap()
                print("SIGNED IN")
            } else {
                print(error!)
            }
        }
        
    }
    
    @IBAction func fbBtnPressed(_ sender: UIButton) {
        
        let login = LoginManager()
        login.logIn([.publicProfile, .email], viewController: self) { (LoginResult) in
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("Cancelled")
            case .success(_, _, _):
                print("Logged In")
                let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    if error == nil {
                        
                        self.ref.child("users").child((user?.uid)!).setValue(["nume": user?.displayName as Any, "email": user?.email as Any, "totalPuncte": 0, "totalCuvinte": 0, "totalPropozitii": 0, "totalExpresii": 0, "totalLectii": 0, "totalExamene": 0, "totalObiectiveComplete": 0])
                        self.goToMap()
                        
                    } else {
                        print(error!)
                    }
                    
                })
            }
        }
    }
    
    private func goToMap() {
        DispatchQueue.main.async(execute: { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
            self.present(viewController, animated: true, completion: nil)
        })
    }
    
}
