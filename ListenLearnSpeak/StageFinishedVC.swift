//
//  LessonFinishedVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import FirebaseAuth

class StageFinishedVC: UIViewController {

    @IBOutlet weak var objImage: UIImageView!
    @IBOutlet weak var objectiveNameLbl: UILabel!
    @IBOutlet weak var congratsLbl: UILabel!
    @IBOutlet weak var pointsWonLbl: UILabel!
    @IBOutlet weak var nextBtn: ButtonWithRadius!

    var userID: String!
    
    var user: User!
    var objective: Objective!
    
    var lessonNr: Int!
    var topicNr: Int!
    var examNr: Int!
    var examSuccess: Int!
    var objName: String!
    var objPoints: Int!
    var tip: String!
    var success: Bool! = false
    var nrOfStages: Int!
    
    var stageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        
        if lessonNr != nil {
            
            stageName = "lectia\(lessonNr!)"
            tip = "lectia"
            objective = Objective(objNr: lessonNr!)
            objImage.image = UIImage(named: "obj_lectia\(self.lessonNr!)")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "X", with: "\(lessonNr!)")
            
            if lessonNr == nrOfStages {
                nextBtn.isHidden = true
            }
            
        } else if topicNr != nil {
            
            stageName = "subiect\(topicNr!)"
            tip = "subiect"
            objective = Objective(objNr: topicNr!)
            objImage.image = UIImage(named: "obj_subiect\(self.topicNr!)")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "lectia", with: "subiectul")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "X", with: "\(topicNr!)")
            nextBtn.setTitle("Subiectul urmator", for: .normal)
            
            if topicNr == nrOfStages {
                nextBtn.isHidden = true
            }
            
        } else if examNr != nil {
            
            stageName = "examen\(examNr!)"
            tip = "examen"
            objective = Objective(objNr: examNr!)
            nextBtn.isHidden = true
            
            if success == true {
                objImage.image = UIImage(named: "obj_examen\(self.examNr!)")
                congratsLbl.text = "Ai promovat!"
            } else {
                objImage.isHidden = true
                objectiveNameLbl.isHidden = true
                pointsWonLbl.isHidden = true
                congratsLbl.text = "Nu ai promovat!"
            }
            
        }else {
            print("nimic")
        }

        // Preia date obiectiv curent pentru actualizarea progresului
        objective.getObj(tip: tip) { (done) in
            
            if done {
                
                // Actualizeaza UI
                self.objectiveNameLbl.text = self.objective.objName
                self.pointsWonLbl.text = self.pointsWonLbl.text?.replacingOccurrences(of: "X", with: "\(self.objective.objPoints)")
                
                // Preia date utilizator + actualizeaza progresul
                self.user.getData(stageName: self.stageName) { (done) in
                    
                    if done {
                        
                        if self.user.obiectiv == 0 {
                            
                            let acordaObiectiv = 1
                            let totalPuncte = self.user.totalPuncte + self.objective.objPoints
                            var totalOb = self.user.totalObiectiveComplete
                            var totalLectii = self.user.totalLectii
                            var totalSubiecte = self.user.totalSubiecte
                            var totalExamene = self.user.totalExamene
                            
                            for (_, en) in self.user.obiective.enumerated() {
                                if let nr = en.value as? Int {
                                    if nr == 0 && self.lessonNr != nil && en.key == "lectia\(self.lessonNr!)" {
                                        totalOb += 1
                                        totalLectii += 1
                                    } else if nr == 0 && self.topicNr != nil && en.key == "subiect\(self.topicNr!)" {
                                        totalOb += 1
                                        totalSubiecte += 1
                                    } else if nr == 0 && self.examNr != nil && en.key == "examen\(self.examNr!)" {
                                        totalOb += 1
                                        totalExamene += 1
                                    }
                                }
                            }
                            
                            if self.lessonNr != nil {
                                let updateUser = ["/users/\(self.userID!)/totalLectii": totalLectii,
                                                  "/users/\(self.userID!)/totalPuncte": totalPuncte,
                                                  "/users/\(self.userID!)/obiective/\(self.stageName)": acordaObiectiv,
                                                  "/users/\(self.userID!)/totalObiectiveComplete": totalOb]
                                self.user.ref.updateChildValues(updateUser)
                            } else if self.topicNr != nil {
                                let updateUser = ["/users/\(self.userID!)/totalSubiecte": totalSubiecte,
                                                  "/users/\(self.userID!)/totalPuncte": totalPuncte,
                                                  "/users/\(self.userID!)/obiective/\(self.stageName)": acordaObiectiv,
                                                  "/users/\(self.userID!)/totalObiectiveComplete": totalOb]
                                self.user.ref.updateChildValues(updateUser)
                            } else if self.examNr != nil && self.success == true {
                                let updateUser = ["/users/\(self.userID!)/totalExamene": totalExamene,
                                                  "/users/\(self.userID!)/totalPuncte": totalPuncte,
                                                  "/users/\(self.userID!)/obiective/\(self.stageName)": acordaObiectiv,
                                                  "/users/\(self.userID!)/totalObiectiveComplete": totalOb]
                                self.user.ref.updateChildValues(updateUser)
                            } else {
                                print("nimic")
                            }
                            
                        } else {
                         
                            self.congratsLbl.text = "Iti place sa repeti nu?"
                            self.pointsWonLbl.text = "Nici un punct pentru tine!"
                            print("Nu se acorda puncte pentru stagiul terminat")
                            
                        }
                        
                    } else {
                        print("error")
                    }
                    
                }
                
            } else {
                print("error")
            }
            
        }
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        self.goToMap()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        self.goToNextStage()
    }
    
    private func goToNextStage() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LearnVC") as! LearnVC
        
        if lessonNr != nil {
            lessonNr = lessonNr! + 1
            controller.lessonNr = lessonNr
        } else if topicNr != nil {
            topicNr = topicNr! + 1
            controller.topicNr = topicNr
        } else {
            print("nimic")
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    private func goToMap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(controller, animated: true, completion: nil)
        
    }

}
