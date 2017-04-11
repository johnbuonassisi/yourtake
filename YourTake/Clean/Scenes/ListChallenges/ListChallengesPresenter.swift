//
//  ListChallengesPresenter.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright (c) 2017 JAB. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListChallengesPresenterInput
{
  func presentFetchedChallenges(response: ListChallenges.FetchChallenges.Response)
}

protocol ListChallengesPresenterOutput: class
{
  func displayFetchedChallenges(viewModel: ListChallenges.FetchChallenges.ViewModel)
}

class ListChallengesPresenter: ListChallengesPresenterInput
{
  weak var output: ListChallengesPresenterOutput!
  
  // MARK: - Presentation logic
  
  func presentFetchedChallenges(response: ListChallenges.FetchChallenges.Response)
  {
    var displayedChallenges: [ListChallenges.FetchChallenges.ViewModel.DisplayedChallenge] = []
    for challenge in response.challenges
    {
      let totalVotesLabel = createTotalVotesLabel(challenge: challenge)
      let expiryLabel = createChallengeExpiryLabel(challenge: challenge)
      
      let displayedChallenge =
        ListChallenges.FetchChallenges.ViewModel.DisplayedChallenge(id: challenge.id,
                                                                    name: challenge.author,
                                                                    imageId: challenge.imageId,
                                                                    challengeImage: challenge.image,
                                                                    expiryLabel: expiryLabel,
                                                                    totalVotesLabel: totalVotesLabel,
                                                                    isDrawButtonEnabled: true,
                                                                    isVoteButton: true)
      displayedChallenges.append(displayedChallenge)
    }
    
    var challengeType =
      ListChallenges.FetchChallenges.ViewModel.ChallengeViewType(rawValue: response.challengeType.rawValue)
    if(displayedChallenges.count == 0)
    {
      challengeType = .noChallenges
    }
    
    let viewModel = ListChallenges.FetchChallenges.ViewModel(challengeType: challengeType!,
                                                             displayedChallenges: displayedChallenges)
    output.displayFetchedChallenges(viewModel: viewModel)
  }
  
  private func createTotalVotesLabel(
    challenge: ListChallenges.FetchChallenges.Response.ChallengeResponseModel) -> String {
    return challenge.totalNumberOfVotes == nil ? "" : "\(challenge.totalNumberOfVotes!) total votes"
  }
  
  private func createChallengeExpiryLabel(
    challenge: ListChallenges.FetchChallenges.Response.ChallengeResponseModel) -> String {
    
    // Calculate the expiry date of the challenge
    let expiryDate: Date
    let diff = challenge.duration + challenge.created.timeIntervalSinceNow
    if diff > 0 {
      expiryDate = Date(timeIntervalSinceNow: diff)
    } else {
      expiryDate = Date(timeIntervalSinceNow: 0)
    }
    
    // Determine how the expiry date should be displayed
    let numSecondsRemaining : Int = Int(expiryDate.timeIntervalSince(Date()))
    
    if( numSecondsRemaining <= 0){
      return String("Challenge completed")
    }
    
    let numDaysRemaining = numSecondsRemaining / ( 60 * 60 * 24)
    if(numDaysRemaining > 0) {
      if numDaysRemaining == 1 {
        return String(numDaysRemaining) + " day remaining"
      }
      return String(numDaysRemaining) + " days remaining"
    }
    
    let numHoursRemaining = numSecondsRemaining / ( 60 * 60 )
    if( numHoursRemaining > 0) {
      if numHoursRemaining == 1 {
        return String(numHoursRemaining) + " hour remaining"
      }
      return String(numHoursRemaining) + " hours remaining"
    }
    
    let numMinutesRemaining = numSecondsRemaining / 60
    if(numMinutesRemaining > 0){
      if numHoursRemaining == 1 {
        return String(numMinutesRemaining) + " minute remaining"
      }
      return String(numMinutesRemaining) + " minutes remaining"
    }
    if numSecondsRemaining == 1 {
      return String(numSecondsRemaining) + "second remaining"
    }
    
    return String(numSecondsRemaining) + " seconds remaining"
  }
  
}
