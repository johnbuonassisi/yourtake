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
    var voters = [String]()
    
    init() {
        let dictionary: [AnyHashable : Any]! =
            ["challengeId": self.challengeId,
             "overlayId": self.overlayId,
             "votes": self.votes,
             "voters": self.voters]
        
        super.init(dictionary: dictionary)
    }

    override init(dictionary: [AnyHashable : Any]!) {
        self.challengeId = dictionary["challengeId"] as! String
        self.overlayId = dictionary["overlayId"] as! String
        self.votes = dictionary["votes"] as! UInt
        if let voters = dictionary["voters"] as? [String] {
            self.voters = voters
        } else {
            self.voters = Array()
        }
        
        super.init(dictionary: dictionary)
     }

    override func collectionName() -> String {
        return "document/takes"
    }
}
