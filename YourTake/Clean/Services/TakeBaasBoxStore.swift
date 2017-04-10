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

}
