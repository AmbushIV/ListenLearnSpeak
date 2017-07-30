//
//  ExamsVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 07/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import EasyTipView

class ExamsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EasyTipViewDelegate {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var examInfoBtn: ButtonWithRadius!
    
    var exam = [Exam]()
    
    weak var tipView: EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        loadCsv()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExamsViewCell", for: indexPath) as? ExamsViewCell {
            let exams = exam[indexPath.row]
            cell.configureCell(exams)
            cell.selectionStyle = .none
            
            let kSeparatorId = 123
            let kSeparatorHeight: CGFloat = 1.7
            
            let separatorView = UIView(frame: CGRect(x: 0, y: cell.frame.height - kSeparatorHeight, width: cell.frame.width, height: kSeparatorHeight))
            separatorView.tag = kSeparatorId
            separatorView.backgroundColor = UIColor.white
            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            cell.addSubview(separatorView)
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exam.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exams = exam[indexPath.row]
        
        goToExam(examId: exams.examId)
    }
    
    private func goToExam(examId: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ExamType1VC") as! ExamType1VC
        controller.examNr = examId
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func examInfoBtnPressed(_ sender: Any) {
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.backgroundColor = examInfoBtn.backgroundColor!
        
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
            
            let text = "Pentru a promova un examen este nevoie sa raspundeti corect la peste 60% din numarul total de intrebari. \n\n Pentru a raspunde trebuie sa traduceti din romana in engleza cuvantul/propozitia afisata. \n\n Pentru a da raspunsul apasati butonul rosu de inregistrare a vocii, dupa ce considerati ca raspunsul este complet mai apasati-l odata si verificati daca raspunsul dvs. este corect!"
            let tip = EasyTipView(text: text, preferences: preferences, delegate: self)
            tip.show(forView: examInfoBtn, withinSuperview: self.navigationController?.view)
            tipView = tip
            
        }

    }
    
    func loadCsv() {
        
        let path = Bundle.main.path(forResource: "exams", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let examId = Int(row["id"]!)!
                let titlu = row["titlu"]!
                
                let exams = Exam(examId: examId)
                exams.getExamTitle(titlu: titlu)
                exam.append(exams)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        // Info dismiss
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tipView?.dismiss(withCompletion: {
            // Info Dismiss
        })
    }

}
