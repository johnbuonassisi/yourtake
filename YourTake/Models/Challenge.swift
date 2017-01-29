//
//  Challenge.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class Challenge: NSObject {
    let id : String
    let author : String
    let image : UIImage
    let recipients : [String]
    let duration : Date
    
    init(id: String, author: String, image: UIImage, recipients: [String], duration: Date) {
        self.id = id
        self.author = author
        self.image = image
        self.recipients = recipients
        self.duration = duration
    }
    
    func isValid() -> Bool {
        if self.image.size.equalTo(CGSize()) || self.duration.timeIntervalSinceNow <= 0 || self.recipients.isEmpty {
            return false
        }
        return true
    }
    
    func submit(_ take: Take) -> Bool {
        let backendClient = Backend.sharedInstance.getClient()
        
        var baSuccess = false
        backendClient.createTake(take, completion: { (success) -> Void in baSuccess = success })
        
        return baSuccess
    }
    
    func getTotalVotes() -> UInt {
        var totalVotes: UInt = 0
        
        let backendClient = Backend.sharedInstance.getClient()
        
        var takes = [Take]()
        backendClient.getTakes(for: self.id, completion: { (objects) -> Void in takes = objects })
        if !takes.isEmpty {
            for take in takes {
                totalVotes += take.votes
            }
        }
        
        return totalVotes
    }
}
