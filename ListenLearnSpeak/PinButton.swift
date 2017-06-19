//
//  PinButton.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 19/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class PinButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentMode = .center
        imageView?.contentMode = .scaleAspectFit
    }

}
