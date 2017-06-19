//
//  Topic.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import Foundation
import Alamofire

class Topic {

    private var _titlu: String!
    private var _subiectId: Int!
    private var _continut = [Dictionary<String, Any>]()
    private var _nrDeSubiecte: Int!
    
    var titlu: String {
        return _titlu
    }
    
    var subiectId: Int {
        return _subiectId
    }
    
    var continut: [Dictionary<String, Any>] {
        return _continut
    }
    
    var nrDeSubiecte: Int {
        if _nrDeSubiecte == nil {
            _nrDeSubiecte = 0
        }
        return _nrDeSubiecte
    }
    
    init(subiectId: Int) {
        self._subiectId = subiectId
    }
    
    func getTopicTitle(titlu: String){
        self._titlu = titlu
    }
    
    func getTopic(completed: @escaping DownloadComplete) {
        
        let URL = "http://listenlearnspeak.xyz/api/topics/\(_subiectId!)/"
        
        Alamofire.request(URL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let titlu = dict["titlu"] as? String {
                    self._titlu = titlu
                    print(titlu)
                }
                
                if let continut = dict["continut"] as? [Dictionary<String, String>] {
                    self._continut = continut
                }
                
            }
            
            completed(true)
            
        }
        
    }
    
    func getTopicsNr(completed: @escaping DownloadComplete) {
        
        let lessonsNrURL = "http://listenlearnspeak.xyz/api/topics/"
        
        Alamofire.request(lessonsNrURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let nrDeSubiecte = dict["nrDeSubiecte"] as? Int {
                    self._nrDeSubiecte = nrDeSubiecte
                }
                
            }
            
            completed(true)
            
        }
        
    }
    
    
}
