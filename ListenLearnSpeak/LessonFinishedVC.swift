//
//  LessonFinishedVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 18/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import FirebaseAuth

class LessonFinishedVC: UIViewController {

    @IBOutlet weak var objImage: UIImageView!
    @IBOutlet weak var objectiveNameLbl: UILabel!
    @IBOutlet weak var congratsLbl: UILabel!
    @IBOutlet weak var pointsWonLbl: UILabel!
    @IBOutlet weak var nextBtn: ButtonWithRadius!

    var userID: String!
    
    var user: User!
    var objective: Objective!
    
    var lessonNr: Int!
    var objName: String!
    var objPoints: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        objective = Objective(objNr: "lectia\(lessonNr!)")
        
        // Preia date obiectiv curent pentru actualizarea progresului
        objective.getObj() { (done) in
            
            if done {
                
                // Actualizeaza UI
                self.objImage.image = UIImage(named: "obj_lesson\(self.lessonNr!)")
                self.objectiveNameLbl.text = self.objective.objName
                self.pointsWonLbl.text = self.pointsWonLbl.text?.replacingOccurrences(of: "X", with: "\(self.objective.objPoints)")
                
                // Preia date utilizator + actualizeaza progresul
                self.user.getData() { (done) in
                    
                    if done {
                        
                        let objComp = self.user.totalObiectiveComplete + 1
                        let totalPuncte = self.user.totalPuncte + self.objective.objPoints
                        
                        let updateUser = ["/users/\(self.userID!)/totalPuncte": totalPuncte,
                                          "/users/\(self.userID!)/totalObiectiveComplete": objComp]
                        self.user.ref.updateChildValues(updateUser)
                        
                    } else {
                        print("error")
                    }
                    
                }
                
            } else {
                print("error")
            }
            
        }
        
        congratsLbl.text = congratsLbl.text?.replacingOccurrences(of: "X", with: "\(lessonNr!)")
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        self.goToMap()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        self.goToNextLesson()
    }
    
    private func goToNextLesson() {
        
        lessonNr = lessonNr! + 1
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LearnVC") as! LearnVC
        controller.lessonNr = lessonNr
        self.present(controller, animated: true, completion: nil)
        
    }
    
    private func goToMap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(controller, animated: true, completion: nil)
        
    }

}
