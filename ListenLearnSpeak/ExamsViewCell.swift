//
//  ExamsViewCell.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 22/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class ExamsViewCell: UITableViewCell {

    @IBOutlet weak var examsTitleLbl: UILabel!
    
    var exam: Exam!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    func configureCell(_ exam: Exam) {
        
        self.exam = exam
        
        examsTitleLbl.text = self.exam.titlu
        
    }

}
