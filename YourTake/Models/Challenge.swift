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
    let duration : TimeInterval
    let created : Date
    
    init(id: String, author: String, image: UIImage, recipients: [String], duration: TimeInterval, created: Date) {
        self.id = id
        self.author = author
        self.image = image
        self.recipients = recipients
        self.duration = duration
        self.created = created
    }
    
    func isValid() -> Bool {
        if self.image.size.equalTo(CGSize()) || self.duration <= 0 || self.recipients.isEmpty {
            return false
        }
        return true
    }
    
    func getTimeRemaining() -> Date {
        let diff = duration + self.created.timeIntervalSinceNow
        if diff > 0 {
            return Date(timeIntervalSinceNow: diff)
        }
        return Date(timeIntervalSinceNow: 0)
    }
    
    func isExpired() -> Bool {
        if duration + self.created.timeIntervalSinceNow <= 0 {
            return true
        }
        return false
    }
    
    func submit(_ take: Take) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.createTake(take, completion: { (success) -> Void in
            if success {
                print("Take created successfully!");
            } else {
                print("Failed to create Take!");
            }
        })
    }
}
