//
//  RegisterVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 06/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passConfirmationField: UITextField!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        fullNameField.delegate = self
        emailField.delegate = self
        passField.delegate = self
        passConfirmationField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
        
    {
        
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
            self.regBtnPressed(nil)
        }
        
        return false
        
    }
    
    @IBAction func regBtnPressed(_ sender: Any?) {
        
        let fullName = fullNameField.text!
        let email = emailField.text!
        let pass = passField.text!
        let passConfirmation = passConfirmationField.text!
        
        if fullName != "" && email != "" && pass != "" {
            if pass == passConfirmation {
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    self.ref.child("users").child((user?.uid)!).setValue(["nume": fullName, "email": self.emailField.text!, "totalPuncte": 0, "totalLectii": 0, "totalExamene": 0, "totalObiectiveComplete": 0, "totalSubiecte": 0, "obiective" : ["lectia1": 0, "lectia2" : 0, "lectia3": 0, "lectia4": 0, "lectia5": 0, "lectia6": 0, "examen1": 0, "examen2": 0, "subiect1": 0, "subiect2": 0 , "subiect3": 0, "subiect4": 0, "subiect5": 0, "subiect6": 0]])
                    self.goToLogin()
               }
            } else {
                let alert = UIAlertController(title: "Eroare", message: "Parolele nu coincid!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Reincearca", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Eroare", message: "Va rugam completati toate campurile!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Reincearca", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func goToLogin() {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
