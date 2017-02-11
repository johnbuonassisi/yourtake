//
//  BaasBoxTake.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxTake: BAAObject {
    var challengeId = String()
    var overlayId = String()
    var votes = UInt(0)
    
    init() {
        let dictionary: [AnyHashable : Any]! =
            ["challengeId": self.challengeId,
             "overlayId": self.overlayId,
             "votes": self.votes]
        
        super.init(dictionary: dictionary)
    }

    override init(dictionary: [AnyHashable : Any]!) {
        self.challengeId = dictionary["challengeId"] as! String
        self.overlayId = dictionary["overlayId"] as! String
        self.votes = dictionary["votes"] as! UInt
        
        super.init(dictionary: dictionary)
     }

    override func collectionName() -> String {
        return "document/takes"
    }
}
