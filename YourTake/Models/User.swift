//
//  User.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class User: NSObject {
    let username : String
    var friends : [String]
    var votes : [String: String]
    
    init(username: String, friends: [String], votes: [String: String]) {
        self.username = username
        self.friends = friends
        self.votes = votes
    }
}
