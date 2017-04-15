//
//  ListChallengesForFriendsTableViewDataSource.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-29.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ListChallengesForFriendsTableViewDataSource: NSObject, UITableViewDataSource {
  
  var displayedChallenges: [ListChallenges.FetchChallenges.ViewModel.DisplayedChallenge] = []
  weak var viewController: ListChallengesViewController!
  
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return displayedChallenges.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeTableViewCell", for: indexPath) as! ChallengeTableViewCell
    
    let displayedChallenge = displayedChallenges[indexPath.row]
    
    cell.name.text = displayedChallenge.name
    cell.challengeImage.image = displayedChallenge.challengeImage
    cell.expiryLabel.text = displayedChallenge.expiryLabel
    cell.totalVotesLabel.text = displayedChallenge.totalVotesLabel
    cell.drawButton.isEnabled = displayedChallenge.isDrawButtonEnabled
    cell.voteButton.setTitle(displayedChallenge.listTakesButtonTitleText, for: .normal)
    
    cell.drawButton.tag = indexPath.row
    cell.drawButton.addTarget(viewController,
                              action: #selector(viewController.cellDrawButtonPressed),
                              for: .touchUpInside)
    
    cell.voteButton.tag = indexPath.row
    cell.voteButton.addTarget(viewController,
                              action: #selector(viewController.cellVoteButtonPressed),
                              for: .touchUpInside)
    
    return cell
  }

}
