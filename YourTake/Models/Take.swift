//
//  Take.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-04.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class Take: NSObject {
    let id : String
    let challengeId : String
    let author : String
    let overlay : UIImage
    var votes : UInt
    
    init(id: String, challengeId: String, author: String, overlay: UIImage, votes: UInt) {
        self.id = id
        self.challengeId = challengeId
        self.author = author
        self.overlay = overlay
        self.votes = votes
    }
    
    func isValid() -> Bool {
        if challengeId.isEmpty || overlay.size.equalTo(CGSize()) {
            return false
        }
        return true
    }
    
    func vote() {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.vote(with: id) { (success) in }
    }
    
    func unvote() {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.unvote(with: id) { (success) in }
    }
}
