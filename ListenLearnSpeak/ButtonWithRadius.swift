//
//  ButtonWithRadius.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 08/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit

class ButtonWithRadius: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5
    }

}
