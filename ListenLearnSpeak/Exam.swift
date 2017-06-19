//
//  Exam.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import Foundation
import Alamofire

class Exam {
 
    private var _titlu: String!
    private var _examId: Int!
    private var _continut = [Dictionary<String, Any>]()
    private var _nrDeExamene: Int!
    
    var titlu: String {
        return _titlu
    }
    
    var examId: Int {
        return _examId
    }
    
    var continut: [Dictionary<String, Any>] {
        return _continut
    }
    
    var nrDeExamene: Int {
        if _nrDeExamene == nil {
            _nrDeExamene = 0
        }
        return _nrDeExamene
    }
    
    init(examId: Int) {
        self._examId = examId
    }
    
    
    func getExam(completed: @escaping DownloadComplete) {
        
        let URL = "http://listenlearnspeak.xyz/api/lessons/\(_examId!)/"
        
        Alamofire.request(URL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let titlu = dict["titlu"] as? String {
                    self._titlu = titlu
                }
                
                if let continut = dict["continut"] as? [Dictionary<String, String>] {
                    self._continut = continut
                }
                
            }
            
            completed(true)
            
        }
        
    }
    
    func getExamsNr(completed: @escaping DownloadComplete) {
        
        let lessonsNrURL = "http://listenlearnspeak.xyz/api/exams/"
        
        Alamofire.request(lessonsNrURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let nrDeExamene = dict["nrDeExamene"] as? Int {
                    self._nrDeExamene = nrDeExamene
                }
                
            }
            
            completed(true)
            
        }
        
    }
    
}
