//
//  SettingsVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 27/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import MediaPlayer
import PopupDialog

class SettingsVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var numeLbl: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    var nume: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        numeLbl.text = nume
        
        soundSwitch.isOn = true
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "soundSwitchState")
        
        titleView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    @IBAction func soundSwitchPressed(_ sender: UISwitch) {
        if soundSwitch.isOn {
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
            UserDefaults.standard.set(true, forKey: "soundSwitchState")
        } else {
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0, animated: false)
            UserDefaults.standard.set(false, forKey: "soundSwitchState")
        }
    }
    
    @IBAction func sendFeedbackPressed(_ sender: Any) {
        showCustomDialog()
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showCustomDialog(animated: Bool = true) {
        
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        let buttonOne = CancelButton(title: "ANULEAZA", height: 60) { }
        let buttonTwo = DefaultButton(title: "TRIMITE", height: 60) { }
        popup.addButtons([buttonOne, buttonTwo])
        present(popup, animated: animated, completion: nil)
        
    }
}
