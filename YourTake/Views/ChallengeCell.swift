//
//  ChallengeCell.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-01.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {
    
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    
    
    static func CellRowHeight() -> CGFloat
    {
        return 481.0;
    }
    
}
