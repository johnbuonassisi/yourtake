//
//  ListChallengesInteractor.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright (c) 2017 JAB. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListChallengesInteractorInput
{
  func fetchChallenges(request: ListChallenges.FetchChallenges.Request)
}

protocol ListChallengesInteractorOutput
{
  func presentFetchedChallenges(response: ListChallenges.FetchChallenges.Response)
}

class ListChallengesInteractor: ListChallengesInteractorInput
{
  var output: ListChallengesInteractorOutput!
  var challengesWorker = ChallengesWorker(challengesStore: ChallengesMemStore())
  
  var userChallenges: [ListChallenges.FetchChallenges.Response.ChallengeResponseModel] = []
  var friendChallenges: [ListChallenges.FetchChallenges.Response.ChallengeResponseModel] = []
  
  // MARK: - Business logic
  
  // fetchChallenges
  //
  // Determine which type of challenges should be fetched from the store (user or friend)
  // Fetch the challenges from the store asynchronously
    // Once the challenges are retrieved, create a response and send to the Presenter if desired
    // For each retrieved challenge
      // Download the associated image asynchronously
        // Update the challenge in the response with the downloaded image
          // Get the number of votes for the challenge asynchronously
            // Update the number of votes in the response
            // Send the response to the Presenter
  
  func fetchChallenges(request: ListChallenges.FetchChallenges.Request)
  {
    let challengeType =
      ListChallenges.FetchChallenges.Response.ChallengeResponseType(rawValue: request.challengeType.rawValue)
    
    switch(request.challengeType) {
    case .userChallenges:
      self.userChallenges.removeAll()
      challengesWorker.fetchChallenges(completionHandler: { (challenges) -> Void in
        for challenge in challenges {
          self.userChallenges.append(
            ListChallenges.FetchChallenges.Response.ChallengeResponseModel(id: challenge.id,
                                                                          author: challenge.author,
                                                                          imageId: challenge.imageId,
                                                                          recipients: challenge.recipients,
                                                                          duration: challenge.duration,
                                                                          created: challenge.created,
                                                                          image: challenge.image,
                                                                          totalNumberOfVotes: nil))
        }
        
        self.fetchChallengeDataAndSendResponseToPresenter(challenges: self.userChallenges,
                                                       challengeType: challengeType!,
                                                       isChallengeAndImageLoadSeparated: true)
        
      })
    case .friendChallenges:
      self.friendChallenges.removeAll()
      challengesWorker.fetchFriendChallenges(completionHandler: { (challenges) -> Void in
        for challenge in challenges {
          self.friendChallenges.append(
            ListChallenges.FetchChallenges.Response.ChallengeResponseModel(id: challenge.id,
                                                                           author: challenge.author,
                                                                           imageId: challenge.imageId,
                                                                           recipients: challenge.recipients,
                                                                           duration: challenge.duration,
                                                                           created: challenge.created,
                                                                           image: challenge.image,
                                                                           totalNumberOfVotes: nil))
        }
        self.fetchChallengeDataAndSendResponseToPresenter(challenges: self.friendChallenges,
                                                       challengeType: challengeType!,
                                                       isChallengeAndImageLoadSeparated: true)
      })
    }
  }

  // fetchChallengeImagesAndSendResponseToPresenter
  //
  // Will get the challenge images and votes for each challenge in the passed in list. The
  // isChallengeAndImageSeparted flag can be used to delay presentation of the challenges
  // until all images have been fetched.
  private func fetchChallengeDataAndSendResponseToPresenter(challenges: [ListChallenges.FetchChallenges.Response.ChallengeResponseModel]?,
                                             challengeType: ListChallenges.FetchChallenges.Response.ChallengeResponseType,
                                             isChallengeAndImageLoadSeparated: Bool) {
    
    if var challenges = challenges {
      let response = ListChallenges.FetchChallenges.Response(challengeType: challengeType,
                                                             challenges: challenges)
      
      if(challenges.count == 0) {
        // When there are no challenges, present something immediately
        output.presentFetchedChallenges(response: response)
        return
      }
      
      if !isChallengeAndImageLoadSeparated {
        // There are some situations (ie. refreshing) where we want to wait for all challenge images
        // to be downloaded before presenting the challenges to the user
        self.output.presentFetchedChallenges(response: response)
      }
      
      for i in 0..<challenges.count { // can't use forin loop here because the array contains structs
        
        // Download each challenge image
        challengesWorker.downloadImage(with: challenges[i].imageId, completion: { (image) -> Void in
          
          challenges[i].image = image
          
          // Get the total number of votes for the challenge
          self.challengesWorker.getNumberOfVotes(for: challenges[i].id, completion: { (totalNumberOfVotes) -> Void in
            
            challenges[i].totalNumberOfVotes = totalNumberOfVotes
            let response = ListChallenges.FetchChallenges.Response(challengeType: challengeType,
                                                                   challenges: challenges)
            self.output.presentFetchedChallenges(response: response)
          })
        })
      }
    } else {
      print("Error: Challenge List is nil")
    }
  }
}
