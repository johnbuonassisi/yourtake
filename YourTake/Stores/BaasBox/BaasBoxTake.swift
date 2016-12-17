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

class BaasBoxTake: BAAObject {
    let challengeId: String
    let overlay: UIImage
    let votes: UInt

    init(dictionary: [NSObject : AnyObject]!) {
        self.challengeId = dictionary["challengeId"]! as String
        self.overlay = dictionary["overlay"]! as UIImage
        self.votes = dictionary["votes"]! as UInt

        super.init(dictionary: dictionary)
     }

    override func collectionName() -> String {
        return "take"
    }
}