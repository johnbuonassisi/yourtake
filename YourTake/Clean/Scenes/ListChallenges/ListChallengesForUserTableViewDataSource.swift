//
//  ListChallengesForUserTableViewDataSource.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-29.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ListChallengesForUserTableViewDataSource: NSObject, UITableViewDataSource {
    
    var displayedChallenges: [ListChallenges.FetchChallenges.ViewModel.DisplayedChallenge] = []
    weak var viewController: ListChallengesViewController!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedChallenges.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListChallengeSceneCellIdentifiers.userChallengeCellId,
                                                 for: indexPath) as! ChallengeTableViewCell
        
        let displayedChallenge = displayedChallenges[indexPath.row]
        
        cell.name.text = displayedChallenge.name
        cell.challengeImage.image = displayedChallenge.challengeImage
        cell.expiryLabel.text = displayedChallenge.expiryLabel
        cell.totalVotesLabel.text = displayedChallenge.totalVotesLabel
        
        cell.drawToolBarButtonItem.isEnabled = displayedChallenge.isDrawButtonEnabled
        cell.drawToolBarButtonItem.tag = indexPath.row
        cell.drawToolBarButtonItem.target = viewController
        cell.drawToolBarButtonItem.action = #selector(viewController.userChallengeCellDrawButtonPressed)
        
        cell.drawTextToolBarButtonItem.isEnabled = displayedChallenge.isDrawButtonEnabled
        cell.drawTextToolBarButtonItem.tag = indexPath.row
        cell.drawTextToolBarButtonItem.target = viewController
        cell.drawTextToolBarButtonItem.action = #selector(viewController.userChallengeCellDrawButtonPressed)
        
        cell.voteToolBarButtonItem.tag = indexPath.row
        cell.voteToolBarButtonItem.target = viewController
        cell.voteToolBarButtonItem.action = #selector(viewController.userChallengeCellVoteButtonPressed)
        
        cell.voteTextToolBarButtonItem.tag = indexPath.row
        cell.voteTextToolBarButtonItem.target = viewController
        cell.voteTextToolBarButtonItem.action = #selector(viewController.userChallengeCellVoteButtonPressed)
        
        return cell
    }
    
}
