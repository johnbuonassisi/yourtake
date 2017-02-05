//
//  BaasBoxChallenge.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxChallenge: BAAObject {
    var imageId = String()
    var durationHrs: Double = 1
    var recipients = [String]()
    
    init() {
        let dictionary: [AnyHashable : Any]! =
            ["imageId": imageId,
             "duration": durationHrs,
             "recipients": recipients]
        
        super.init(dictionary: dictionary)
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        self.imageId = dictionary["imageId"] as! String
        self.durationHrs = dictionary["duration"] as! Double
        self.recipients = dictionary["recipients"] as! [String]
        
        super.init(dictionary: dictionary)
    }

    override func collectionName() -> String {
        return "document/challenges"
    }
}
