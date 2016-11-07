//
//  User.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let name : String
    let friends : [String]
    var challenges: [Challenge]?
    
    init(name: String, friends: [String])
    {
        self.name = name;
        self.friends = friends;
    }
    
    func add(challenge: Challenge)
    {
        if(challenges == nil)
        {
            challenges = [Challenge]()
        }
        
        challenges!.append(challenge)
        challenges = challenges!.sorted(by:
            {c1, c2 in return c2.expiryDate as Date > c1.expiryDate as Date})
    }

}
