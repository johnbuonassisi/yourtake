//
//  EmptyChallengeCell.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-01-28.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class EmptyChallengeCell: UITableViewCell {

    @IBOutlet weak var createNewChallengeButton: UIButton!
    
    static func CellRowHeight() -> CGFloat
    {
        return 481.0;
    }
}
