
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
import EasyTipView

class LearnVC: UIViewController, UIScrollViewDelegate, AVSpeechSynthesizerDelegate, EasyTipViewDelegate {
    
    @IBOutlet weak var learnSV: UIScrollView!
    @IBOutlet weak var pageControlMap: UIPageControl!
    @IBOutlet weak var progressView: StepProgressBar!
    @IBOutlet weak var listenBtn: ButtonWithRadius!
    @IBOutlet weak var nextBtn: ButtonWithRadius!
    @IBOutlet weak var tipInfo: UIView!
    @IBOutlet weak var tipInfoBtn: ButtonWithRadius!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    var lesson: Lesson!
    var topic: Topic!
    
    var titluLectie: String!
    var lessonNr: Int!
    var topicNr: Int!
    
    weak var tipView: EasyTipView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnSV.delegate = self
        synth.delegate = self
        
        nextBtn.isUserInteractionEnabled = false
        
        if lessonNr != nil {
            
            lesson = Lesson(lectieId: lessonNr)
            
            lesson.getLesson() { (done) in
                
                if done {
                    
                    let slidesCount = self.lesson.continut.count
                    let enumerated = self.lesson.continut.enumerated()
                    
                    self.loadFeatures(slidesCount: slidesCount, enumerated: enumerated)
                    self.progressView.stepsCount = slidesCount
                    self.pageControlMap.numberOfPages = slidesCount
                    self.pageControlMap.currentPage = 0
                    let textToSpeech = self.lesson.continut[0]["EN"] as! String
                    self.myUtterance = AVSpeechUtterance(string: textToSpeech)
                    self.myUtterance.rate = 0.1
                    
                } else {
                    print("Eroare: Lectie nepreluata")
                }
                
            }
            
        } else if topicNr != nil {
            
            topic = Topic(subiectId: topicNr)
            
            topic.getTopic() { (done) in
                
                if done {
                    
                    let slidesCount = self.topic.continut.count
                    let enumerated = self.topic.continut.enumerated()
                    
                    self.loadFeatures(slidesCount: slidesCount, enumerated: enumerated)
                    self.progressView.stepsCount = slidesCount
                    self.pageControlMap.numberOfPages = slidesCount
                    self.pageControlMap.currentPage = 0
                    let textToSpeech = self.topic.continut[0]["EN"] as! String
                    self.myUtterance = AVSpeechUtterance(string: textToSpeech)
                    self.myUtterance.rate = 0.1
                    
                } else {
                    print("Eroare: Subiect nepreluat")
                }
                
            }
            
        } else {
            print("no")
        }

    }
    
    @IBAction func tipInfoBtnPressed(_ sender: Any) {
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.backgroundColor = tipInfoBtn.backgroundColor!
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
        preferences.drawing.arrowPosition = .top
        
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                // Info Dismiss
            })
        } else {
            let text = "A - ai \n B - bee \n C - see \n D - dee"
            let tip = EasyTipView(text: text, preferences: preferences, delegate: self)
            tip.show(forView: tipInfoBtn)
            tipView = tip
        }
        
    }
    
    func loadFeatures(slidesCount: Int, enumerated: EnumeratedSequence<[Dictionary<String, Any>]>) {
        
        let scrollViewWidth = learnSV.frame.width
        let scrollViewHeight = learnSV.frame.height
        
        learnSV.isPagingEnabled = true
        learnSV.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        learnSV.contentSize = CGSize(width: scrollViewWidth * CGFloat(slidesCount), height: scrollViewHeight)
        
        for (index, feature) in enumerated {
            
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
        
        var textToSpeech: String!
        
        if lessonNr != nil {
            textToSpeech = self.lesson.continut[pageControlMap.currentPage]["EN"] as! String
        } else if topicNr != nil {
            textToSpeech = self.topic.continut[pageControlMap.currentPage]["EN"] as! String
        } else {
            print("nimic")
        }
        
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
            
            // Stagiu terminat, acorda obiectiv + punctaj
            if lessonNr != nil {
                self.finishStage(stageID: lessonNr)
            } else if topicNr != nil {
                self.finishStage(stageID: topicNr)
            } else {
                print("nimic")
            }
        
        } else {
            
            scrollToPage(pageControlMap.currentPage+1)
            listenBtn.setTitle("ASCULTA", for: .normal)
            nextBtn.isUserInteractionEnabled = false
            nextBtn.backgroundColor = hexStringToUIColor(hex: "22355A")
            
        }
        
    }
    
    private func finishStage(stageID: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StageFinishedVC") as! StageFinishedVC
        
        if lessonNr != nil {
            controller.lessonNr = stageID
        } else if topicNr != nil {
            controller.topicNr = stageID
        } else {
            print("nimic")
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        // Info dismissed
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Atentie!", message: "Daca iesi acum vei pierde tot progresul!", preferredStyle: .alert)
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.present(controller, animated: true, completion: nil)
            
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
