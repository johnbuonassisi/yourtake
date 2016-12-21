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

    init(data: [String : Any]!) {
        self.challengeId = data["challengeId"] as! String
        self.overlay = data["overlay"] as? UIImage
        self.votes = data["votes"] as! UInt
        
        super.init(dictionary: data)
     }

    override func collectionName() -> String {
        return "take"
    }
}
