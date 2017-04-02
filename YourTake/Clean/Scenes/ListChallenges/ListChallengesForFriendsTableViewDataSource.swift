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
    cell.challengeImage = UIImageView()
    cell.expiryLabel.text = displayedChallenge.expiryLabel
    cell.totalVotesLabel.text = displayedChallenge.totalVotesLabel
    cell.drawButton.isEnabled = displayedChallenge.isDrawButtonEnabled
    cell.voteButton.isEnabled = displayedChallenge.isVoteButton
    
    return cell
  }

}
