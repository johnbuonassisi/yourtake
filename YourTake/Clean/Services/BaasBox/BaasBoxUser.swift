//
//  BaasBoxTake.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

import UIKit

class BaasBoxUser: BAAObject {
    var email = String()
    var votes = [String: String]()
    
    override init(dictionary: [AnyHashable : Any]!) {
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        if let votes = dictionary["votes"] as? [String: String] {
            self.votes = votes
        }
        
        super.init(dictionary: dictionary)
    }
    
    override func collectionName() -> String {
        return "document/users"
    }
}
