//
//  BorderedButton.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-15.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }

}
