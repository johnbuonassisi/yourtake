/**
 * Copyright (c) 2016 Enovi Inc.
 *
 * All rights reserved. Unauthorized reproduction or distribution of this file, via any medium, in
 * whole or in part, is strictly prohibited except by express written permission of Enovi Inc.
 */

/**
 * @author Olivier Thomas
 */

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
