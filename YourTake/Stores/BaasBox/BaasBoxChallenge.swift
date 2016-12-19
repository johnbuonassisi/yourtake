//
//  BaasBoxChallenge.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxChallenge: BAAObject {
    var photo: UIImage?
    var durationHrs: UInt = 1
    var users: [String]?
    
    init(data: [String : Any]!) {
        self.photo = data["photo"] as? UIImage
        self.durationHrs = data["duration"] as! UInt
        self.users = data["users"] as? [String]
        
        super.init(dictionary: data)
    }

    override func collectionName() -> String {
        return "challenge"
    }
}
