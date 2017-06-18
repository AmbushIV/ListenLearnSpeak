
//
//  TextViewStyle.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 13/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class TextViewStyle: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
