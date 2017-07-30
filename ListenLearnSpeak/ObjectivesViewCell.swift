//
//  ObjectivesViewCell.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 21/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class ObjectivesViewCell: UICollectionViewCell {
    
    @IBOutlet weak var objMark: UIImageView!
    @IBOutlet weak var objImage: UIImageView!
    @IBOutlet weak var objTitle: UILabel!
    
    var objective: Objective!
    
    func configureCell(_ objective: Objective) {
        
        self.objective = objective
        
        if self.objective.objAchieved == 1 {
            objImage.alpha = 1
            objTitle.alpha = 1
            objMark.isHidden = false
        } else {
            objImage.alpha = 0.5
            objTitle.alpha = 0.5
            objMark.isHidden = true
        }
        
        objTitle.text = self.objective.objName
        objImage.image = UIImage(named: "obj_\(self.objective.objKey)")
        
    }
    
}
