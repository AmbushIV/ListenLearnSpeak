
//
//  LearnVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 12/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire
import StepProgressBar

class LearnVC: UIViewController, UIScrollViewDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var learnSV: UIScrollView!
    @IBOutlet weak var pageControlMap: UIPageControl!
    @IBOutlet weak var progressView: StepProgressBar!
    @IBOutlet weak var listenBtn: ButtonWithRadius!
    @IBOutlet weak var nextBtn: ButtonWithRadius!
    
    
    private var _arrayContent: Array<String> = []
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var lesson: Lesson!
    
    var titluLectie: String!
    var lessonNr: Int!
    var btnPressed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lesson = Lesson(lectieId: lessonNr)
        
        learnSV.delegate = self
        synth.delegate = self
        
        nextBtn.isUserInteractionEnabled = false
        
        lesson.getLesson() { (done) in
            
            if done {
                
                let slidesCount = self.lesson.continut.count
                
                if self.lessonNr != nil {
                    
                    self.loadFeatures()
                    self.progressView.stepsCount = slidesCount
                    self.pageControlMap.numberOfPages = slidesCount
                    self.pageControlMap.currentPage = 0
                    let textToSpeech = self.lesson.continut[0]["EN"] as! String
                    self.myUtterance = AVSpeechUtterance(string: textToSpeech)
                    self.myUtterance.rate = 0.1
                    
                } else {
                    print("Numar lectie inexistent")
                }
                
            } else {
                print("Can't get lesson")
            }
            

        }

    }
    
    func loadFeatures() {
        
        let scrollViewWidth = learnSV.frame.width
        let scrollViewHeight = learnSV.frame.height
        
        learnSV.isPagingEnabled = true
        learnSV.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        learnSV.contentSize = CGSize(width: scrollViewWidth * CGFloat(lesson.continut.count), height: scrollViewHeight)
        
        for (index, feature) in lesson.continut.enumerated() {
            
            if let featureView = Bundle.main.loadNibNamed("LearnSlider", owner: self, options: nil)?.first as? LearnSlider {
                
                featureView.roTextLbl.text = feature["RO"] as! String
                featureView.textToListenLbl.text = feature["EN"] as! String
                
                learnSV.addSubview(featureView)
                featureView.frame = CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                
            }
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/view.frame.width))
        
        pageControlMap.currentPage = pageIndex
        
        progressView.progress = pageControlMap.currentPage + 1
        
        let textToSpeech = self.lesson.continut[pageControlMap.currentPage]["EN"] as! String
        self.myUtterance = AVSpeechUtterance(string: textToSpeech)
        self.myUtterance.rate = 0.1
        
    }
    
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 1) {
            self.learnSV.contentOffset.x = self.learnSV.frame.width * CGFloat(page)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        listenBtn.setTitle("REASCULTA", for: .normal)
    }
    
    @IBAction func listenBtnPressed(_ sender: Any) {
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/view.frame.width))
        
        synth.speak(myUtterance)
        nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = hexStringToUIColor(hex: "3B6FB2")
        
        if pageIndex + 1 == pageControlMap.numberOfPages {
            nextBtn.setTitle("FINALIZEAZA", for: .normal)
        }
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/view.frame.width))
        pageControlMap.currentPage = pageIndex
        
        if pageControlMap.currentPage + 1 == pageControlMap.numberOfPages {
            
            //Code to add
            print("Final nivel")
            self.finishLesson(lectieId: lessonNr)
        
        } else {
            
            scrollToPage(pageControlMap.currentPage+1)
            listenBtn.setTitle("ASCULTA", for: .normal)
            nextBtn.isUserInteractionEnabled = false
            nextBtn.backgroundColor = hexStringToUIColor(hex: "22355A")
            
        }
        
    }
    
    private func finishLesson(lectieId: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LessonFinishedVC") as! LessonFinishedVC
        controller.lessonNr = lectieId
        self.present(controller, animated: true, completion: nil)
        
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Atentie!", message: "Daca iesi acum vei pierde tot progresul!", preferredStyle: .alert)
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(acceptAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
