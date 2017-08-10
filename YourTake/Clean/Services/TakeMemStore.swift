//
//  TakeMemStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class TakeMemStore: TakesStoreProtocol {
  
  var user: User = User(username: "john",
                        friends: ["ashling", "daniella", "anthony", "andrea", "peter"],
                        votes: ["1" : "1"])
  var takes: [TakeDto] = [TakeDto(id: "1",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "ashling",
                                  //overlay: UIImage(named: "John_Challenge.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 1),
                          TakeDto(id: "2",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "ted",
                                  //overlay: UIImage(named: "John_Challenge_Andrea.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 2),
                          TakeDto(id: "3",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "jared",
                                  //overlay: UIImage(named: "John_Challenge_Anthony.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 3),
                          TakeDto(id: "4",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "daniella",
                                  //overlay: UIImage(named: "John_Challenge_Ashling.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 1),
                          TakeDto(id: "5",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "anthony",
                                  //overlay: UIImage(named: "John_Challenge_Peter.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 5),
                          TakeDto(id: "6",
                                  challengeId: "1",
                                  imageId: "",
                                  author: "bob",
                                  //overlay: UIImage(named: "John_Challenge_2.jpg", in: nil, compatibleWith: nil)!,
                                  votes: 7)]
  
  func fetchUser(completion: @escaping (User?) -> Void) {
    completion(user)
  }
  
  func fetchTakes(challengeId: String, completionHandler: @escaping(_ takes: () throws -> [TakeDto]) -> Void) {
    takes = takes.sorted { $0.votes > $1.votes }
    completionHandler{ return takes }
  }
  
  func voteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
//    for take in takes {
//      if take.id == takeId {
//        take.votes += 1
//      }
//    }
    completionHandler(true)
  }
  
  func unvoteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
//    for take in takes {
//      if take.id == takeId {
//        take.votes -= 1
//      }
//    }
    completionHandler(true)
  }
  
  func isChallengeExpired(challengeId: String, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(false)
  }


}
