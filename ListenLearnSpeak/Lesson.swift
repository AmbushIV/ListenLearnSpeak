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
    
    var titlu: String {
        return _titlu
    }
    
    var lectieId: Int {
        return _lectieId
    }
    
    var continut: [Dictionary<String, Any>] {
        return _continut
    }

    init(lectieId: Int) {
        self._lectieId = lectieId
    }
    
    func getSubj(titlu: String){
        self._titlu = titlu
    }
    
    func getLesson(completed: @escaping DownloadComplete) {
        
        let URL = "http://listenlearnspeak.xyz/api/lessons/\(_lectieId!)/"

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

    
}
