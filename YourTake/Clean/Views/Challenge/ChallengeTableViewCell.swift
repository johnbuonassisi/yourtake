//
//  ChallengeTableViewCell.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var challengeImage: UIImageView!
  @IBOutlet weak var expiryLabel: UILabel!
  @IBOutlet weak var totalVotesLabel: UILabel!
  @IBOutlet weak var drawButton: UIButton!
  @IBOutlet weak var voteButton: UIButton!
  
  static func CellRowHeight() -> CGFloat
  {
    return 481.0;
  }
  
  func getImageForCell(with id: String, completion: @escaping (UIImage?) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.downloadImage(with: id, completion: { (image) -> Void in
      completion(image)
    })
  }
    
}
