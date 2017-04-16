//
//  SwipelessNavigationController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-12-07.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class SwipelessNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        interactivePopGestureRecognizer?.isEnabled = false
    }

}
