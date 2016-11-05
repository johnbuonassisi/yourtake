//
//  Submission.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-04.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class Submission: NSObject {
    
    let image : UIImage
    let name : String
    
    init(image: UIImage, name: String)
    {
        self.image = image
        self.name = name
    }

}
