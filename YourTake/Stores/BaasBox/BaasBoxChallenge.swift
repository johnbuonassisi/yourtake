//
//  BaasBoxChallenge.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxChallenge: BAAObject {
    var image: UIImage?
    var durationHrs: Double = 1
    var recipients = [String]()
    
    init() {
        let dictionary: [AnyHashable : Any]! =
            ["image": UIImage(),
             "duration": durationHrs,
             "recipients": recipients]
        
        super.init(dictionary: dictionary)
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        self.image = dictionary["image"] as? UIImage
        self.durationHrs = dictionary["duration"] as! Double
        self.recipients = dictionary["recipients"] as! [String]
        
        super.init(dictionary: dictionary)
    }

    override func collectionName() -> String {
        return "document/challenges"
    }
}
