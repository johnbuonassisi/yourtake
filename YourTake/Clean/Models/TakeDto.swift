//
//  TakeDto.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-08.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class TakeDto: NSObject {
  
  let id : String
  let challengeId : String
  let imageId : String
  let author : String
  var overlay : UIImage?
  var votes : UInt
  
  init(id: String, challengeId: String, imageId: String, author: String, votes: UInt) {
    self.id = id
    self.challengeId = challengeId
    self.imageId = imageId
    self.author = author
    self.overlay = nil
    self.votes = votes
  }
  
  func isValid() -> Bool {
    if let overlay = self.overlay {
        if challengeId.isEmpty || overlay.size.equalTo(CGSize()) {
            return false
        }
        return true
    }
    return false
  }

}
