//
//  ChallengesMemStore.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ChallengesMemStore: ChallengesStoreProtocol {
  
  var challenges = [ChallengeDto(id: "1",
                              author: "John",
                              imageId: "1",
                              recipients: ["Ashling"],
                              duration: 1000,
                              created: Date()),
                    ChallengeDto(id: "2",
                              author: "John",
                              imageId: "2",
                              recipients: ["Ashling"],
                              duration: 2000, created: Date())]
  
  var friendChallenges = [ChallengeDto(id: "3",
                              author: "Ashling",
                              imageId: "3",
                              recipients: ["John"],
                              duration: 1000,
                              created: Date()),
                    ChallengeDto(id: "4",
                              author: "Anthony",
                              imageId: "4",
                              recipients: ["John"],
                              duration: 2000, created: Date())]
  
  func fetchChallenges(completionHandler: @escaping ([ChallengeDto], ChallengesStoreError?) -> Void) {
    completionHandler(challenges, nil)
  }
  
  func fetchChallenges(completionHandler: @escaping (() throws -> [ChallengeDto]) -> Void) {
    completionHandler { return self.challenges }
  }
  
  func fetchChallenges(completionHandler: @escaping (ChallengesStoreResult<[ChallengeDto]>) -> Void) {
    completionHandler(ChallengesStoreResult.Success(result: challenges))
  }
  
  func fetchFriendChallenges(completionHandler: @escaping (() throws -> [ChallengeDto]) -> Void) {
    completionHandler { return self.friendChallenges }
  }
  
  func downloadImage(with id: String, completion: @escaping (UIImage?) -> Void) {
    switch id {
    case "1":
      completion(UIImage(named: "Ashling_Challenge_Andrea.jpg", in: nil, compatibleWith: nil))
    case "2":
      completion(UIImage(named: "Ashling_Challenge_Anthony.jpg", in: nil, compatibleWith: nil))
    case "3":
      completion(UIImage(named: "Ashling_Challenge_John.jpg", in: nil, compatibleWith: nil))
    case "4":
      completion(UIImage(named: "Ashling_Challenge_Peter.jpg", in: nil, compatibleWith: nil))
    default:
      completion(UIImage(named: "Ashling_Challenge_Peter.jpg", in: nil, compatibleWith: nil))
    }
  }
  
  func getNumberOfVotes(for challengeId: String, completion: @escaping (UInt) -> Void) {
    completion(10)
  }

}
