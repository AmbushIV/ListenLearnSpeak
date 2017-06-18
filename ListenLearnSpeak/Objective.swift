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
    
    private var _objNr: String!
    private var _objName: String!
    private var _objPoints: Int!
    
    var objNr: String {
        if _objNr == nil {
            _objNr = ""
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
    
    
    init(objNr: String) {
        self._objNr = objNr
    }
    
    func getObj(completed: @escaping DownloadComplete) {
        
        ref = Database.database().reference()
        
        ref.child("Obiective").child(objNr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Preia date utilizator
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
    
}
