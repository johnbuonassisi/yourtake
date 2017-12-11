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
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var voteToolBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var voteTextToolBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var drawToolBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var drawTextToolBarButtonItem: UIBarButtonItem!
    
    private static let cellHeaderHeight: CGFloat = Constants.Dimensions.navigationBarHeight;
    private static let cellFooterHeight: CGFloat = Constants.Dimensions.toolBarHeight;
    
    static func getHeightofCell(for screenWidth: CGFloat) -> CGFloat {
        return cellHeaderHeight + screenWidth + cellFooterHeight
    }
}
