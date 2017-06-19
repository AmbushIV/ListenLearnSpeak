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
    var objName: String!
    var objPoints: Int!
    
    var stageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        
        if lessonNr != nil {
            
            stageName = "lectia\(lessonNr!)"
            objective = Objective(objNr: "lectia\(lessonNr!)")
            objImage.image = UIImage(named: "obj_lesson\(self.lessonNr!)")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "X", with: "\(lessonNr!)")
            
        } else if topicNr != nil {
            
            stageName = "subiect\(topicNr!)"
            objective = Objective(objNr: "subiect\(topicNr!)")
            objImage.image = UIImage(named: "obj_topic\(self.topicNr!)")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "lectia", with: "subiectul")
            congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "X", with: "\(topicNr!)")
            nextBtn.setTitle("Subiectul urmator", for: .normal)
            
        } else {
            print("nimic")
        }

        // Preia date obiectiv curent pentru actualizarea progresului
        objective.getObj() { (done) in
            
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
                            var totalOb = 1
                            
                            for (_, en) in self.user.obiective {
                                if let nr = en as? Int {
                                    if nr == 1 {
                                        totalOb += 1
                                    }
                                }
                                
                            }
                            
                            let updateUser = ["/users/\(self.userID!)/totalPuncte": totalPuncte,
                                              "/users/\(self.userID!)/obiective/\(self.stageName)": acordaObiectiv,
                                              "/users/\(self.userID!)/totalObiectiveComplete": totalOb]
                            self.user.ref.updateChildValues(updateUser)

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
