//
//  LessonSelectCell.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 12/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class LessonSelectCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLessonLbl: UILabel!
    
    var lesson: Lesson!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    func configureCell(_ lesson: Lesson) {
        
        self.lesson = lesson
        
        titleLessonLbl.text = self.lesson.titlu.capitalized
        
    }
}
