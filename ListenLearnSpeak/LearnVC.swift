//
//  LearnVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 12/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import AVFoundation
import StepProgressBar
import EasyTipView

class LearnVC: UIViewController, UIScrollViewDelegate, AVSpeechSynthesizerDelegate, EasyTipViewDelegate, UIGestureRecognizerDelegate {
    
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
    var infoText: String!
    var nrOfLessons: Int!
    var nrOfTopics: Int!
    
    weak var tipView: EasyTipView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnSV.delegate = self
        synth.delegate = self
        
        nextBtn.isUserInteractionEnabled = false
        
        if lessonNr != nil {
            
            lesson = Lesson(lectieId: lessonNr)
            lesson.getLessonsNr() { (bool) in self.nrOfLessons = self.lesson.nrDeLectii }
            
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
                    self.infoText = self.lesson.infoText
                    
                } else {
                    print("Eroare: Lectie nepreluata")
                }
                
            }
            
        } else if topicNr != nil {
            
            topic = Topic(subiectId: topicNr)
            topic.getTopicsNr() { (bool) in self.nrOfTopics = self.topic.nrDeSubiecte }
            
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
        preferences.drawing.arrowPosition = .bottom
        
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                // Info Dismiss
            })
        } else {
            
            let textInfo = infoText.replacingOccurrences(of: "\\n", with: "\n")
            
            if textInfo == "" {
                print("No info")
            } else {
                let tip = EasyTipView(text: textInfo, preferences: preferences, delegate: self)
                tip.show(forView: tipInfoBtn, withinSuperview: self.navigationController?.view)
                tipView = tip
            }
            
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
                let textToListenLbl = featureView.textToListenLbl!
                textToListenLbl.text = feature["EN"] as! String
                let spacedText = textToListenLbl.text?.replacingOccurrences(of: "\\n", with: "\n")
                textToListenLbl.text = spacedText
                
                learnSV.addSubview(featureView)
                featureView.frame = CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                
                let textToAttribute = textToListenLbl.text!
                let textToAttributeArray = textToAttribute.components(separatedBy: " ")
                let attributedText = NSMutableAttributedString()
                
                for word in textToAttributeArray{
                    
                    let attributePending = NSMutableAttributedString(string: word + " ")
                    let myRange = NSRange(location: 0, length: word.characters.count)
                    let myCustomAttribute = [ "Tapped Word:": word]
                    attributePending.addAttributes(myCustomAttribute, range: myRange)
                    attributedText.append(attributePending)
                    
                }
                
                textToListenLbl.attributedText = attributedText
                textToListenLbl.font = UIFont(name: "Helvetica", size: 20)
                textToListenLbl.textAlignment = .center
                textToListenLbl.textColor = UIColor.white
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(HandleTaps))
                tap.delegate = self
                textToListenLbl.addGestureRecognizer(tap)
                
            }
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/learnSV.frame.width))
        
        pageControlMap.currentPage = pageIndex
        
        progressView.progress = pageIndex + 1
        
        var textToSpeech: String!
        var newTextToSpeech: String!
        
        if lessonNr != nil {
            textToSpeech = self.lesson.continut[pageControlMap.currentPage]["EN"] as! String
            newTextToSpeech = textToSpeech.replacingOccurrences(of: "\\n", with: "-")
            infoText = self.lesson.continut[pageControlMap.currentPage]["info"] as! String
        } else if topicNr != nil {
            textToSpeech = self.topic.continut[pageControlMap.currentPage]["EN"] as! String
            newTextToSpeech = textToSpeech.replacingOccurrences(of: "\\n", with: "-")
        } else {
            print("nimic")
        }
        
        myUtterance = AVSpeechUtterance(string: newTextToSpeech)
        myUtterance.rate = 0.1
        
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
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/learnSV.frame.width))
        
        synth.speak(myUtterance)
        nextBtn.isUserInteractionEnabled = true
        nextBtn.backgroundColor = hexStringToUIColor(hex: "3B6FB2")
        
        if pageIndex + 1 == pageControlMap.numberOfPages {
            nextBtn.setTitle("FINALIZEAZA", for: .normal)
        }
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        let pageIndex = Int(round(self.learnSV.contentOffset.x/learnSV.frame.width))
        pageControlMap.currentPage = pageIndex
        
        if pageControlMap.currentPage + 1 == pageControlMap.numberOfPages {
            
            // Stagiu terminat, acorda obiectiv + punctaj
            if lessonNr != nil {
                self.finishStage(stageID: lessonNr, nrOfStages: nrOfLessons)
            } else if topicNr != nil {
                self.finishStage(stageID: topicNr, nrOfStages: nrOfTopics)
            } else {
                print("Nimic acordat")
            }
        
        } else {
            
            if let tipView = tipView {
                tipView.dismiss(withCompletion: {
                    // Info Dismiss
                })
            } else {
                // Nimic
            }
            
            scrollToPage(pageControlMap.currentPage+1)
            listenBtn.setTitle("ASCULTA", for: .normal)
            nextBtn.isUserInteractionEnabled = false
            nextBtn.backgroundColor = hexStringToUIColor(hex: "22355A")
            
        }
        
    }
    
    private func finishStage(stageID: Int, nrOfStages: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StageFinishedVC") as! StageFinishedVC
        
        if lessonNr != nil {
            controller.lessonNr = stageID
            controller.nrOfStages = nrOfStages
        } else if topicNr != nil {
            controller.topicNr = stageID
            controller.nrOfStages = nrOfStages
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
            self.tipView?.dismiss(withCompletion: {
                // Info Dismiss
            })
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(acceptAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @objc func HandleTaps(sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < myTextView.textStorage.length {
            
            let attributeName = "Tapped Word:"
            let attributeValue = myTextView.attributedText.attribute(NSAttributedStringKey(rawValue: attributeName), at: characterIndex, effectiveRange: nil) as? String
            if let value = attributeValue {
                print("You tapped on: \(value)")
                myUtterance = AVSpeechUtterance(string: value)
                myUtterance.rate = 0.1
                synth.speak(myUtterance)
            }
            
        }
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
