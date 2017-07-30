//
//  ExamType1VC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 22/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import StepProgressBar
import EasyTipView

class ExamType1VC: UIViewController, SFSpeechRecognizerDelegate, UIScrollViewDelegate, EasyTipViewDelegate {
    
    @IBOutlet weak var pageControlMap: UIPageControl!
    @IBOutlet weak var verifyBtn: ButtonWithRadius!
    @IBOutlet weak var roLangScrollView: UIScrollView!
    @IBOutlet weak var textFromSpeech: TextViewStyle!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var examStepsProgress: StepProgressBar!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var exam: Exam!
    
    weak var tipView: EasyTipView?
    var preferences = EasyTipView.Preferences()
    
    var examNr: Int!
    var nrOfExams: Int!
    var examSuccess: Int!
    var textToVerify: String!
    var correctText: String!
    var points: Int = 0
    var success: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        roLangScrollView.delegate = self
        
        recordBtn.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        verifyBtn.isEnabled = false
        verifyBtn.backgroundColor = hexStringToUIColor(hex: "22355A")

        textFromSpeech.text = "Apasa butonul rosu pentru a incepe!"
        
        if examNr != nil {
            exam = Exam(examId: examNr)
            exam.getExamsNr() { (bool) in self.nrOfExams = self.exam.nrDeExamene }
            
            exam.getExam() { (done) in
                
                if done {
                    
                    let slidesCount = self.exam.continut.count
                    let slidesCountFloat = CGFloat(slidesCount)
                    let enumerated = self.exam.continut.enumerated()
                    
                    self.loadFeatures(slidesCount: slidesCount, enumerated: enumerated)
                    self.examStepsProgress.stepsCount = slidesCount
                    self.pageControlMap.numberOfPages = slidesCount
                    self.pageControlMap.currentPage = 0
                    self.textToVerify = self.exam.continut[0]["EN"] as? String
                    self.correctText = self.exam.correctText
                    self.examSuccess = Int(round(slidesCountFloat - (0.4 * slidesCountFloat)))
                    
                } else {
                    print("Eroare: examen nepreluat")
                }
                
            }
        } else {
            print("Examen invalid")
        }
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("Utilizatorul a refuzat accessul la recunoasterea vocii")
                
            case .restricted:
                isButtonEnabled = false
                print("Recunoasterea vocii este restrictionata pe acest dispozitiv")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Recunoasterea vocii nu a fost autorizata")
            }
            
            OperationQueue.main.addOperation() {
                self.recordBtn.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    func loadFeatures(slidesCount: Int, enumerated: EnumeratedSequence<[Dictionary<String, Any>]>) {
        
        let scrollViewWidth = roLangScrollView.frame.width
        let scrollViewHeight = roLangScrollView.frame.height
        
        roLangScrollView.isPagingEnabled = true
        roLangScrollView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
        roLangScrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(slidesCount), height: scrollViewHeight)
        
        for (index, feature) in enumerated {
            
            if let featureView = Bundle.main.loadNibNamed("ExamType1Slider", owner: self, options: nil)?.first as? ExamType1Slider {
                
                featureView.roTextLbl.text = feature["RO"] as! String
                
                roLangScrollView.addSubview(featureView)
                featureView.frame = CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                
            }
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(round(self.roLangScrollView.contentOffset.x/roLangScrollView.frame.width))
        
        pageControlMap.currentPage = pageIndex
        
        examStepsProgress.progress = pageIndex + 1
        
        if examNr != nil {
            textToVerify = self.exam.continut[pageControlMap.currentPage]["EN"] as! String
            correctText = self.exam.continut[pageControlMap.currentPage]["correctText"] as! String
        } else {
            print("nimic")
        }
        
    }
    
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 1) {
            self.roLangScrollView.contentOffset.x = self.roLangScrollView.frame.width * CGFloat(page)
        }
    }
    
    @IBAction func verifyBtnPressed(_ sender: Any) {
        
        let pageIndex = Int(round(self.roLangScrollView.contentOffset.x/roLangScrollView.frame.width))
        pageControlMap.currentPage = pageIndex
        
        if verifyBtn.currentTitle == "CONTINUA" {
            scrollToPage(pageControlMap.currentPage+1)
            verifyBtn.setTitle("VERIFICA", for: .normal)
            verifyBtn.isEnabled = false
            verifyBtn.backgroundColor = hexStringToUIColor(hex: "22355A")
            
            if let tipView = tipView {
                tipView.dismiss(withCompletion: {
                    // Info Dismiss
                })
            } else {
                // Nimic
            }
        
        } else if verifyBtn.currentTitle == "VERIFICA" {
            if textToVerify.caseInsensitiveCompare(textFromSpeech.text) == ComparisonResult.orderedSame {
                print("Adevarat")
                points = points + 1
                verifyBtn.setTitle("CONTINUA", for: .normal)
                verifyBtn.backgroundColor = hexStringToUIColor(hex: "#27B374")
                
                if pageControlMap.currentPage + 1 == pageControlMap.numberOfPages {
                    verifyBtn.setTitle("FINALIZEAZA", for: .normal)
                    verifyBtn.backgroundColor = hexStringToUIColor(hex: "#27B374")
                } else {
                    
                }
            } else {
                print("Ai gresit")
                verifyBtn.setTitle("CONTINUA", for: .normal)
                verifyBtn.backgroundColor = hexStringToUIColor(hex: "#E6410B")
                
                preferences.drawing.backgroundColor = verifyBtn.backgroundColor!
                
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
                    
                    let textInfo = correctText.replacingOccurrences(of: "\\n", with: "\n")
                    
                    if textInfo == "" {
                        print("No info")
                    } else {
                        let tip = EasyTipView(text: textInfo, preferences: preferences, delegate: self)
                        tip.show(forView: verifyBtn, withinSuperview: self.navigationController?.view)
                        tipView = tip
                    }
                    
                }
                
                if pageControlMap.currentPage + 1 == pageControlMap.numberOfPages {
                    verifyBtn.setTitle("FINALIZEAZA", for: .normal)
                    verifyBtn.backgroundColor = hexStringToUIColor(hex: "#E6410B")
                } else {
                    
                }
                
            }
        } else if verifyBtn.currentTitle == "FINALIZEAZA" {
            print("FINAL")
            
            if let tipView = tipView {
                tipView.dismiss(withCompletion: {
                    // Info Dismiss
                })
            } else {
                
                let textInfo = correctText.replacingOccurrences(of: "\\n", with: "\n")
                
                if textInfo == "" {
                    print("No info")
                } else {
                    let tip = EasyTipView(text: textInfo, preferences: preferences, delegate: self)
                    tip.show(forView: verifyBtn, withinSuperview: self.navigationController?.view)
                    tipView = tip
                }
                
            }
            
            if points >= examSuccess {
                success = true
            } else {
                success = false
            }
            
            self.finishStage(stageID: self.examNr, success: self.success)
            
        }
        
    }
    
    private func finishStage(stageID: Int, success: Bool) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StageFinishedVC") as! StageFinishedVC
        
        controller.examNr = stageID
        controller.success = success
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        // Info dismiss
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        let imgStop = UIImage(named: "record_stop.png")
        let imgStart = UIImage(named: "record_start.png")
        recordBtn.setImage(imgStop, for: .normal)
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordBtn.isEnabled = false
            recordBtn.setImage(imgStart, for: .normal)
            verifyBtn.isEnabled = true
            verifyBtn.backgroundColor = hexStringToUIColor(hex: "3B6FB2")
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textFromSpeech.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textFromSpeech.text = "Vorbeste, te ascult!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordBtn.isEnabled = true
        } else {
            recordBtn.isEnabled = false
        }
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
