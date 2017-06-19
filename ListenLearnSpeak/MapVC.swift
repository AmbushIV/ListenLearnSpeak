//
//  MapVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 07/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import FirebaseAuth

class MapVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var loadBg: UIImageView!
    @IBOutlet weak var mapSliderSV: UIScrollView!
    @IBOutlet weak var pageControlMap: UIPageControl!
    @IBOutlet weak var gettingDataLoader: UIActivityIndicatorView!
    
    var userID: String!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        
        mapSliderSV.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.loadFeatures()
        
        user.getData(stageName: "") { (done) in
            if done {
                self.mapSliderSV.isHidden = false
                self.gettingDataLoader.stopAnimating()
                self.loadBg.isHidden = true
            } else {
                self.mapSliderSV.isHidden = true
            }
            
        }
        
    }
    
    func loadFeatures() {
        
        let scrollViewWidth = mapSliderSV.frame.width
        let scrollViewHeight = mapSliderSV.frame.height
        
        mapSliderSV.isPagingEnabled = true
        mapSliderSV.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        mapSliderSV.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
        
        if let featureView = Bundle.main.loadNibNamed("MapSlide", owner: self, options: nil)?.first as? MapSlide {
            
            // Seteaza titlurile lectiilor
            featureView.lesson1Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView.lesson2Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView.lesson3Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView.lesson4Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            mapSliderSV.addSubview(featureView)
            
        }
        
        if let featureView2 = Bundle.main.loadNibNamed("MapSlide2", owner: self, options: nil)?.first as? MapSlide2 {
            
            // Seteaza titlurile lectiilor
            featureView2.lesson5Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView2.lesson6Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView2.lesson7Btn.addTarget(self, action:#selector(self.goToLessonAction(_sender:)), for: .touchUpInside)
            featureView2.frame = CGRect(x: view.frame.width , y: 0, width: view.frame.width, height: view.frame.height)
            mapSliderSV.addSubview(featureView2)
            
                if self.user.totalLectii >= 4 {
                    featureView2.isUserInteractionEnabled = true
                    featureView2.lockedStage.alpha = 0
                } else {
                    featureView2.isUserInteractionEnabled = false
                    featureView2.lockedStage.alpha = 0.5
                }
            
        }
        
    }
    
    public func goToLessonAction(_sender: UIButton) {
        let lessonNrInt = Int(_sender.title(for: .normal)!)!
        self.goToLesson(lectieId: lessonNrInt)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(self.mapSliderSV.contentOffset.x/view.frame.width))
        pageControlMap.currentPage = pageIndex
    }
    
    private func goToLesson(lectieId: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LearnVC") as! LearnVC
        controller.lessonNr = lectieId
        self.present(controller, animated: true, completion: nil)
        
    }

}
