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
    
    static func CellRowHeight() -> CGFloat
    {
        return 375.0;
    }
    
}
