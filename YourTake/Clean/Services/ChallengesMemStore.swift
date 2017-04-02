//
//  ChallengesMemStore.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ChallengesMemStore: ChallengesStoreProtocol {
  
  /*
  var challenges = [ChallengeDto(id: "1",
                              author: "John",
                              image: UIImage(),
                              recipients: ["Ashling"],
                              duration: 1000,
                              created: Date()),
                    ChallengeDto(id: "2",
                              author: "John",
                              image: UIImage(),
                              recipients: ["Ashling"],
                              duration: 2000, created: Date())]
 */
  
  var challenges: [ChallengeDto] = []
  
  var friendChallenges = [ChallengeDto(id: "1",
                              author: "Ashling",
                              imageId: "1",
                              recipients: ["John"],
                              duration: 1000,
                              created: Date()),
                    ChallengeDto(id: "2",
                              author: "Anthony",
                              imageId: "2",
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
    completion(UIImage())
  }

}
