//
//  EmptyChallengeTableViewCell.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-29.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class EmptyChallengeTableViewCell: UITableViewCell {

  @IBOutlet weak var createNewChallengeButton: UIButton!
  
  static func CellRowHeight() -> CGFloat {
    return 481.0;
  }
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
  }
}
