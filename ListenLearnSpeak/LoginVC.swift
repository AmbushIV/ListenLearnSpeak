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
import PopupDialog

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if AccessToken.current?.authenticationToken != nil {
            self.goToMap()
        } else {
            
        }
        
        emailField.delegate = self
        passField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next
        {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                
                nextField.becomeFirstResponder()
                
            } else {
                
                textField.resignFirstResponder()
                
                return true
                
            }
        }
        
        if textField.returnKeyType == UIReturnKeyType.go
        {
            self.loginBtnPressed(nil)
        }
        
        return false
        
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton?) {
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passField.text!) { (user, error) in
            if error == nil {
                self.goToMap()
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
                        
                        self.ref.child("users").child((user?.uid)!).setValue(["nume": user?.displayName as Any, "email": user?.email as Any, "totalPuncte": 0, "totalLectii": 0, "totalExamene": 0, "totalObiectiveComplete": 0, "totalSubiecte": 0, "obiective" : ["lectia1": 0, "lectia2" : 0, "lectia3": 0, "lectia4": 0, "lectia5": 0, "lectia6": 0, "examen1": 0, "examen2": 0, "subiect1": 0, "subiect2": 0 , "subiect3": 0, "subiect4": 0, "subiect5": 0, "subiect6": 0]])
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        //testsss
    }
    
}
