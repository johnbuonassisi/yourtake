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

}
