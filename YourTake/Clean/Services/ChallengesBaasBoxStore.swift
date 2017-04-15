//
//  ChallengesBaasBoxStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-01.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ChallengesBaasBoxStore: ChallengesStoreProtocol {

    func fetchChallenges(completionHandler: @escaping ([ChallengeDto], ChallengesStoreError?) -> Void) {
        
        // get initial data from source
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getChallengeList(for: false, completion:{ (challengeDtos) -> Void in
            completionHandler(challengeDtos, nil)
        })
    }
    
    func fetchChallenges(completionHandler: @escaping (() throws -> [ChallengeDto]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getChallengeList(for: false, completion:{ (challengeDtos) -> Void in
            completionHandler{challengeDtos}
        })
    }
    
    func fetchChallenges(completionHandler: @escaping (ChallengesStoreResult<[ChallengeDto]>) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getChallengeList(for: false, completion:{ (challengeDtos) -> Void in
            completionHandler(ChallengesStoreResult.Success(result: challengeDtos))
        })
    }
    
    func fetchFriendChallenges(completionHandler: @escaping (() throws -> [ChallengeDto]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getChallengeList(for: true, completion:{ (challengeDtos) -> Void in
            completionHandler { return challengeDtos }
        })
    }
  
  func downloadImage(with id: String, completion: @escaping (UIImage?) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.downloadImage(with: id, completion: { (image) -> Void in
      completion(image)
    })
  }
  
  func getNumberOfVotes(for challengeId: String, completion: @escaping (UInt) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.getTakeList(for: challengeId, completion: { (takes) -> Void in
      var totalVotes: UInt = 0
      for take in takes {
        totalVotes += take.votes
      }
      completion(totalVotes)
    })
  }

}
