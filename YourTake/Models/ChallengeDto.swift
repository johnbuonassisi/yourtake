//
//  ChallengeDto.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-01.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ChallengeDto: NSObject {

    let id : String
    let author : String
    let imageId : String
    let recipients : [String]
    let duration : TimeInterval
    let created : Date
    var image: UIImage?
  
    init(id: String, author: String, imageId: String, recipients: [String], duration: TimeInterval, created: Date) {
        self.id = id
        self.author = author
        self.imageId = imageId
        self.recipients = recipients
        self.duration = duration
        self.created = created
        self.image = nil
    }
    
    func isValid() -> Bool {
        if let image = self.image {
            if image.size.equalTo(CGSize()) || self.duration <= 0 || self.recipients.isEmpty {
                return false
            }
            return true
        }
        return false
    }
    
    func getTimeRemaining() -> Date {
        let diff = duration + self.created.timeIntervalSinceNow
        if diff > 0 {
            return Date(timeIntervalSinceNow: diff)
        }
        return Date(timeIntervalSinceNow: 0)
    }


}
