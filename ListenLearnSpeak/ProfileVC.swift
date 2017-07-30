//
//  ProfileVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 07/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import GTProgressBar
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var expLbl: UILabel!
    @IBOutlet weak var objCompletedLbl: UILabel!
    @IBOutlet weak var totalLessonsLbl: UILabel!
    @IBOutlet weak var totalTopicsLbl: UILabel!
    @IBOutlet weak var totalExamsLbl: UILabel!
    @IBOutlet weak var totalPointsLbl: UILabel!
    @IBOutlet weak var lessonsProgress: GTProgressBar!
    @IBOutlet weak var topicsProgress: GTProgressBar!
    @IBOutlet weak var examsProgress: GTProgressBar!
    @IBOutlet weak var pointsProgress: GTProgressBar!
    @IBOutlet weak var lessonsTrophy: UIImageView!
    @IBOutlet weak var topicsTrophy: UIImageView!
    @IBOutlet weak var examsTrophy: UIImageView!
    @IBOutlet weak var pointsTrophy: UIImageView!
    
    var user: User!
    var lesson: Lesson!
    var topic: Topic!
    var exam: Exam!
    
    var userID: String!
    
    var totalLessonsProgressValue: CGFloat = 0.0
    var totalTopicsProgressValue: CGFloat = 0.0
    var totalExamsProgressValue: CGFloat = 0.0
    var totalPointsProgressValue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        lesson = Lesson(lectieId: 0)
        topic = Topic(subiectId: 0)
        exam = Exam(examId: 0)
 
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        user.getData(stageName: "") { (done) in
            
            if done {
                
                self.nameLbl.text = self.user.nume
                
                self.objCompletedLbl.text = self.objCompletedLbl.text?.replacingOccurrences(of: "X", with: "\(self.user.totalObiectiveComplete)")
                
                self.totalPointsLbl.text = self.totalPointsLbl.text?.replacingOccurrences(of: "X", with: "\(self.user.totalPuncte)")
                
                self.totalPointsProgressValue = CGFloat(self.user.totalPuncte) / 485.0
                
                self.pointsProgress.animateTo(progress: self.totalPointsProgressValue)
                
                if self.totalPointsProgressValue == 1 {
                    self.pointsTrophy.image = UIImage(named: "obj_points_trophyFilled.png")
                } else {
                    self.pointsTrophy.image = UIImage(named: "obj_points_trophy.png")
                }
                
                self.lesson.getLessonsNr() { (done) in
                    if done {
                        
                        self.totalLessonsProgressValue =  CGFloat(self.user.totalLectii) / CGFloat(self.lesson.nrDeLectii)
                        
                        self.totalLessonsLbl.text = self.totalLessonsLbl.text?.replacingOccurrences(of: "X / Y", with: "\(self.user.totalLectii) / \(self.lesson.nrDeLectii)", options: .regularExpression)
                        
                        if self.totalLessonsProgressValue == 1 {
                            self.lessonsTrophy.image = UIImage(named: "obj_lesson_trophyFilled.png")
                        } else {
                            self.lessonsTrophy.image = UIImage(named: "obj_lesson_trophy.png")
                        }
                        
                        self.lessonsProgress.animateTo(progress: self.totalLessonsProgressValue)
                        
                    } else {
                        print("Eroare: Numarul de lectii nu a putut fi preluat")
                    }
                }
                
                self.topic.getTopicsNr() { (done) in
                    if done {
                        
                        self.totalTopicsProgressValue =  CGFloat(self.user.totalSubiecte) / CGFloat(self.topic.nrDeSubiecte)
                        
                        self.totalTopicsLbl.text = self.totalTopicsLbl.text?.replacingOccurrences(of: "X / Y", with: "\(self.user.totalSubiecte) / \(self.topic.nrDeSubiecte)", options: .regularExpression)
                        
                        if self.totalTopicsProgressValue == 1 {
                            self.topicsTrophy.image = UIImage(named: "obj_topic_trophyFilled.png")
                        } else {
                            self.topicsTrophy.image = UIImage(named: "obj_topic_trophy.png")
                        }
                        
                        self.topicsProgress.animateTo(progress: self.totalTopicsProgressValue)
                        
                    } else {
                        print("Eroare: Numarul de subiecte nu a putut fi preluat")
                    }
                }
                
                self.exam.getExamsNr() { (done) in
                    if done {
                        
                        self.totalExamsProgressValue =  CGFloat(self.user.totalExamene) / CGFloat(self.exam.nrDeExamene)
                        
                        self.totalExamsLbl.text = self.totalExamsLbl.text?.replacingOccurrences(of: "X / Y", with: "\(self.user.totalExamene) / \(self.exam.nrDeExamene)", options: .regularExpression)
                        
                        if self.totalExamsProgressValue == 1 {
                            self.examsTrophy.image = UIImage(named: "obj_exam_trophyFilled.png")
                        } else {
                            self.examsTrophy.image = UIImage(named: "obj_exam_trophy.png")
                        }
                        
                        self.examsProgress.animateTo(progress: self.totalExamsProgressValue)
                        
                    } else {
                        print("Eroare: Numarul de examene nu a putut fi preluat")
                    }
                }
                
            } else {
                print("Eroare: utilizatorul nu a putut fi preluat")
            }
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        totalLessonsProgressValue = 0
        totalTopicsProgressValue = 0
        totalExamsProgressValue = 0
        totalPointsProgressValue = 0
        lessonsProgress.animateTo(progress: totalLessonsProgressValue)
        topicsProgress.animateTo(progress: totalTopicsProgressValue)
        examsProgress.animateTo(progress: totalExamsProgressValue)
        pointsProgress.animateTo(progress: totalPointsProgressValue)
        
    }
    
    @IBAction func objectivesBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObjectivesVC") as! ObjectivesVC
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        controller.nume = nameLbl.text!
        self.present(controller, animated: true, completion: nil)
    }
    
    

}
