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

}
