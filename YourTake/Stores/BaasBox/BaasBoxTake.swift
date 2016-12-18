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
