//
//  ListChallengesTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-05.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UIKit

protocol ListChallengesTableViewDataSourceDelegate: class {
    func drawOnChallenge(inRow row: Int)
    func voteOnChallenge(inRow row: Int)
}

class ListChallengesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var displayedChallenges: [ListChallenges.FetchChallenges.ViewModel.DisplayedChallenge] = []
    weak var delegate: ListChallengesTableViewDataSourceDelegate!
    
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
        cell.drawToolBarButtonItem.target = self
        cell.drawToolBarButtonItem.action = #selector(self.cellDrawButtonPressed)
        
        cell.drawTextToolBarButtonItem.isEnabled = displayedChallenge.isDrawButtonEnabled
        cell.drawTextToolBarButtonItem.tag = indexPath.row
        cell.drawTextToolBarButtonItem.target = self
        cell.drawTextToolBarButtonItem.action = #selector(self.cellDrawButtonPressed)
        
        cell.voteToolBarButtonItem.tag = indexPath.row
        cell.voteToolBarButtonItem.target = self
        cell.voteToolBarButtonItem.action = #selector(self.cellVoteButtonPressed)
        
        cell.voteTextToolBarButtonItem.tag = indexPath.row
        cell.voteTextToolBarButtonItem.target = self
        cell.voteTextToolBarButtonItem.action = #selector(self.cellVoteButtonPressed)
        
        return cell
    }
    
    @objc private func cellDrawButtonPressed(sender: UIBarButtonItem!) {
        delegate.drawOnChallenge(inRow: sender.tag)
    }
    
    @objc private func cellVoteButtonPressed(sender: UIBarButtonItem!) {
        delegate.voteOnChallenge(inRow: sender.tag)
    }
    
}
