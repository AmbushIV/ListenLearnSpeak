//
//  User.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User {
    
    var ref: DatabaseReference!
    
    private var _userID: String!
    private var _nume: String!
    private var _email: String!
    private var _totalCuvinte: Int!
    private var _totalExamene: Int!
    private var _totalExpresii: Int!
    private var _totalLectii: Int!
    private var _totalObiectiveComplete: Int!
    private var _totalPropozitii: Int!
    private var _totalPuncte: Int!
    
    var userID: String {
        return _userID
    }
    
    var email: String {
        if _email == nil {
            _email = "john.doe@gmail.com"
        }
        return _email
    }

    var nume: String {
        if _nume == nil {
            _nume = "John Doe"
        }
        return _nume
    }
    
    var totalCuvinte: Int {
        if _totalCuvinte == nil {
            _totalCuvinte = 0
        }
        return _totalCuvinte
    }
    
    var totalExamene: Int {
        if _totalExamene == nil {
            _totalExamene = 0
        }
        return _totalExamene
    }
    
    var totalExpresii: Int {
        if _totalExpresii == nil {
            _totalExpresii = 0
        }
        return _totalExpresii
    }
    
    var totalLectii: Int {
        if _totalLectii == nil {
            _totalLectii = 0
        }
        return _totalLectii
    }
    
    var totalObiectiveComplete: Int {
        if _totalObiectiveComplete == nil {
            _totalObiectiveComplete = 0
        }
        return _totalObiectiveComplete
    }
    
    var totalPropozitii: Int {
        if _totalPropozitii == nil {
            _totalPropozitii = 0
        }
        return _totalPropozitii
    }
    
    var totalPuncte: Int {
        if _totalPuncte == nil {
            _totalPuncte = 0
        }
        return _totalPuncte
    }
    
    init(userID: String) {
        self._userID = userID
    }
    
    func getData(completed: @escaping DownloadComplete) {
        
        ref = Database.database().reference()
        
        ref.child("users").child(_userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Preia date utilizator
            if let userData = snapshot.value as? Dictionary<String, Any> {
                
                if let email = userData["email"] as? String {
                    self._email = email
                }
                
                if let nume = userData["nume"] as? String {
                    self._nume = nume
                }
                
                if let totalCuvinte = userData["totalCuvinte"] as? Int {
                    self._totalCuvinte = totalCuvinte
                }
                
                if let totalExamene = userData["totalExamene"] as? Int {
                    self._totalExamene = totalExamene
                }
                
                if let totalExpresii = userData["totalExpresii"] as? Int {
                    self._totalExpresii = totalExpresii
                }
                
                if let totalLectii = userData["totalLectii"] as? Int {
                    self._totalLectii = totalLectii
                }
                
                if let totalObiectiveComplete = userData["totalObiectiveComplete"] as? Int {
                    self._totalObiectiveComplete = totalObiectiveComplete
                }
                
                if let totalPropozitii = userData["totalPropozitii"] as? Int {
                    self._totalPropozitii = totalPropozitii
                }
                
                if let totalPuncte = userData["totalPuncte"] as? Int {
                    self._totalPuncte = totalPuncte
                }
                
            }
            
            completed(true)
            
        }) { (error) in
            print(error.localizedDescription)
            completed(false)
        }
        
    }
    
}
