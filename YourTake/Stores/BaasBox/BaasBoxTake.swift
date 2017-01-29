//
//  BaasBoxTake.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxTake: BAAObject {
    var challengeId: String = ""
    var overlay: UIImage?
    var votes: UInt = 0

    override init(dictionary: [AnyHashable : Any]!) {
        self.challengeId = dictionary["challengeId"] as! String
        self.overlay = dictionary["overlay"] as? UIImage
        self.votes = dictionary["votes"] as! UInt
        
        super.init(dictionary: dictionary)
     }

    override func collectionName() -> String {
        return "document/takes"
    }
}
