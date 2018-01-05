//
//  ListFriendChallengesViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-04.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UIKit

class ListFriendChallengesViewController: ListChallengesViewControllerV2 {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.challengeRequestType = .friendChallenges
        ListChallengesConfigurator.sharedInstance.configure(viewController: self)
    }
}
