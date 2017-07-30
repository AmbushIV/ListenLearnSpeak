//
//  ObjectivesVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 20/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import EasyTipView
import FirebaseAuth

class ObjectivesVC: UIViewController, EasyTipViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var infoBarItem: UIBarButtonItem!
    @IBOutlet weak var loadImg: UIImageView!
    @IBOutlet weak var objLoader: UIActivityIndicatorView!
    
    weak var tipView: EasyTipView?
    var userID: String!
    
    var objectives = [Objective]()
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser?.uid
        
        user = User(userID: userID!)
        
        collection.dataSource = self
        collection.delegate = self
        
        loadCsv()
        
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        
        
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                // Info Dismiss
            })
        } else {
            
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = hexStringToUIColor(hex: "#1E80F4")
            
            let text = "Obiectivele reprezinta un mod de a va tine motivati. \n\n Pentru a obtine cat mai multe stele si in final trofeul pentru toate lectiile/subiectele/examenele tot ce trebuie sa faceti este sa le parcurgeti/promovati. \n\n Mult success!"
            let tip = EasyTipView(text: text, preferences: preferences, delegate: self)
            tip.show(forItem: infoBarItem)
            tipView = tip
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectivesViewCell", for: indexPath) as? ObjectivesViewCell {
            
            var objective: Objective!
            
            user.checkObjectives { (done) in
                if done {
                    let sortObj = self.user.obiective.sorted(by: { $0.0 < $1.0 })
                    for (_, values) in sortObj.enumerated() {
                        
                        if values.key == self.objectives[indexPath.row].objKey {
                            
                            if values.value as? Int == 0 {
                                // Nimic
                            } else {
                                
                                self.objectives[indexPath.row].objAchieved = values.value as! Int
                                objective = self.objectives[indexPath.row]
                                cell.configureCell(objective)
                                cell.reloadInputViews()
                                
                            }
                            
                        }
                     
                        self.loadImg.isHidden = true
                        self.objLoader.stopAnimating()
                        
                    }
                } else {
                    //Nimic
                }
            }
            
            objective = self.objectives[indexPath.row]
            cell.configureCell(objective)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Nimic
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objectives.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func loadCsv() {
        
        let path = Bundle.main.path(forResource: "obiective", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                
                let objNr = Int(row["id"]!)!
                let asignare = row["asignare"]!
                let nume = row["nume"]!
                
                let objective = Objective(objNr: objNr)
                objective.getObjData(objK: asignare, objN: nume)
                
                objectives.append(objective)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        // Info dismiss
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        tipView?.dismiss(withCompletion: {
            // Info Dismiss
        })
        self.dismiss(animated: true, completion: nil)
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
