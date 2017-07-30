//
//  Lesson.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 11/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import Foundation
import Alamofire

class Lesson {
    
    private var _titlu: String!
    private var _lectieId: Int!
    private var _continut = [Dictionary<String, Any>]()
    private var _nrDeLectii: Int!
    private var _infoText: String!
    
    var titlu: String {
        return _titlu
    }
    
    var lectieId: Int {
        return _lectieId
    }
    
    var continut: [Dictionary<String, Any>] {
        return _continut
    }
    
    var nrDeLectii: Int {
        if _nrDeLectii == nil {
            _nrDeLectii = 0
        }
        return _nrDeLectii
    }
    
    var infoText: String {
        if _infoText == nil {
            _infoText = ""
        }
        return _infoText
    }

    init(lectieId: Int) {
        self._lectieId = lectieId
    }
    
    
    func getLesson(completed: @escaping DownloadComplete) {
        
        let URL = "http://listenlearnspeak.xyz/api/lessons/\(_lectieId!)/"

        Alamofire.request(URL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let titlu = dict["titlu"] as? String {
                    self._titlu = titlu
                }
                
                if let continut = dict["continut"] as? [Dictionary<String, Any>] {
                    self._continut = continut
                    
                    if let infoText = continut[0]["info"] as? String {
                        self._infoText = infoText
                    }
                    
                }
                
            }
            
            completed(true)
            
        }
        
    }
    
    func getLessonsNr(completed: @escaping DownloadComplete) {
        
        let lessonsNrURL = "http://listenlearnspeak.xyz/api/lessons/"
        
        Alamofire.request(lessonsNrURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let nrDeLectii = dict["nrDeLectii"] as? Int {
                    self._nrDeLectii = nrDeLectii
                }
                
            }
            
            completed(true)
            
        }
        
    }

    
}
