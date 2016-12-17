/**
 * Copyright (c) 2016 Enovi Inc.
 *
 * All rights reserved. The methods and techniques described herein are considered 
 * trade secrets and/or confidential. Reproduction or distribution, in whole or in 
 * part, is forbidden except by express written permission of Enovi Inc.
 **/

/**
 * @author Olivier Thomas
 */

import UIKit

class BaasBoxChallenge: BAAObject {
    var photo: UIImage
    var durationHrs: UInt
    var users: [String]

    init(dictionary: [NSObject : AnyObject]!) {
        self.photo = dictionary["photo"]! as UImage
        self.durationHrs = dictionary["duration"]! as UInt
        self.users = dictionary["users"]! as [String]

        super.init(dictionary: dictionary)
     }

    override func collectionName() -> String {
        return "challenge"
    }
}