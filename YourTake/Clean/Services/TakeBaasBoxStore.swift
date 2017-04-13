//
//  TakeBaasBoxStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class TakeBaasBoxStore: TakesStoreProtocol {
  
  func fetchUser(completion: @escaping (User?) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.getUser(completion: completion)
  }
  
  func fetchTakes(challengeId: String, completionHandler: @escaping(_ takes: () throws -> [TakeDto]) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.getTakeDtos(for: challengeId, completion: { (takes) -> Void in
        completionHandler{ return takes}
    })
  }
  
  func voteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.vote(with: takeId, completion: completionHandler)
  }
  
  func unvoteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.unvote(with: takeId, completion: completionHandler)
  }
  
  func isChallengeExpired(challengeId: String, completionHandler: @escaping (Bool) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.getChallengeDto(with: challengeId, completion: { (challenge) -> Void in
        
        if let challenge = challenge {
        
            let expiryDate: Date
            let diff = challenge.duration + challenge.created.timeIntervalSinceNow
            if diff > 0 {
                expiryDate = Date(timeIntervalSinceNow: diff)
            } else {
                expiryDate = Date(timeIntervalSinceNow: 0)
            }
        
            let numberOfSecondsRemainingInChallenge = Int(expiryDate.timeIntervalSince(Date()))
            if numberOfSecondsRemainingInChallenge <= 0 {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            completionHandler(true)
        }
    })
  }

}
