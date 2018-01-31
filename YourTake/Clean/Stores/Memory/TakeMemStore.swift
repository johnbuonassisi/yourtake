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
                                    imageId: "1",
                                    author: "ashling",
                                    votes: 1,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"]),
                            TakeDto(id: "2",
                                    challengeId: "1",
                                    imageId: "2",
                                    author: "ted",
                                    votes: 2,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"]),
                            TakeDto(id: "3",
                                    challengeId: "1",
                                    imageId: "3",
                                    author: "jared",
                                    votes: 3,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"]),
                            TakeDto(id: "4",
                                    challengeId: "1",
                                    imageId: "1",
                                    author: "daniella",
                                    votes: 1,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"]),
                            TakeDto(id: "5",
                                    challengeId: "1",
                                    imageId: "2",
                                    author: "anthony",
                                    votes: 5,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"]),
                            TakeDto(id: "6",
                                    challengeId: "1",
                                    imageId: "3",
                                    author: "bob",
                                    votes: 7,
                                    voters: ["ashling", "daniella", "anthony", "andrea", "peter"])]
    
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
    
    func doesTakeExist(forChallenge challengeId: String, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}
