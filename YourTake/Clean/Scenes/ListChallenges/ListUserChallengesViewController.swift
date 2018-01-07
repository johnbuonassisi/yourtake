//
//  ListUserChallengesViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-04.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UIKit

class ListUserChallengesViewController: ListChallengesViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.challengeRequestType = .userChallenges
        ListChallengesConfigurator.sharedInstance.configure(viewController: self)
    }
    
}
