//
//  Objective.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Objective {
    
    var ref: DatabaseReference!
    
    private var _objNr: Int!
    private var _objName: String!
    private var _objPoints: Int!
    private var _objAchieved: Int = 0
    private var _objData: Dictionary<String, Any>!
    private var _objKey: String!
    
    var objAchieved: Int {
        get {
            return _objAchieved
        }
        set {
            _objAchieved = newValue
        }
    }
    
    var objNr: Int {
        if _objNr == nil {
            _objNr = 0
        }
        return _objNr
    }
    
    var objName: String {
        if _objName == nil {
            _objName = ""
        }
        return _objName
    }
    
    var objPoints: Int {
        if _objPoints == nil {
            _objPoints = 0
        }
        return _objPoints
    }
    
    var objData: Dictionary<String, Any> {
        return _objData
    }
    
    var objKey: String {
        if _objKey == nil {
            _objKey = ""
        }
        return _objKey
    }
    
    init(objNr: Int) {
        self._objNr = objNr
    }
    
    func getObj(tip: String, completed: @escaping DownloadComplete) {
        
        ref = Database.database().reference()
        
        ref.child("Obiective").child("\(tip)\(objNr)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Preia date obiective
            if let objData = snapshot.value as? Dictionary<String, Any> {
                
                if let objName = objData["nume"] as? String {
                    self._objName = objName
                }
                
                if let objPoints = objData["puncte"] as? Int {
                    self._objPoints = objPoints
                }
                
            }
            
            completed(true)
            
        }) { (error) in
            print(error.localizedDescription)
            completed(false)
        }

    }
    
    func getObjData(objK: String, objN: String) {
        
        self._objKey = objK
        self._objName = objN
        
    }
    
    
    
}
