//
//  TakesWorker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class TakesWorker {
    
    var takeStore: TakesStoreProtocol
    
    init(takeStore: TakesStoreProtocol) {
        self.takeStore = takeStore
    }
    
    func fetchUser(completion: @escaping (User?) -> Void) {
        takeStore.fetchUser(completion: completion)
    }
    
    func fetchTakes(challengeId: String, completionHandler: @escaping(_ takes: [TakeDto]) -> Void) {
        takeStore.fetchTakes(challengeId: challengeId, completionHandler: { (takes) in
            do {
                let takes = try takes()
                completionHandler(takes)
            } catch {
                completionHandler([])
            }
        })
    }
    
    func voteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
        takeStore.voteForTake(takeId: takeId, completionHandler: completionHandler)
    }
    
    func unvoteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void) {
        takeStore.unvoteForTake(takeId: takeId, completionHandler: completionHandler)
    }
    
    func isChallengeExpired(challengeId: String, completionHandler: @escaping (Bool) -> Void) {
        takeStore.isChallengeExpired(challengeId: challengeId, completionHandler: completionHandler)
    }
    
    func doesTakeExist(forChallenge challengeId: String, completionHandler: @escaping (Bool) -> Void) {
        takeStore.doesTakeExist(forChallenge: challengeId, completionHandler: completionHandler)
    }
    
}

protocol TakesStoreProtocol {
    
    func fetchUser(completion: @escaping (User?) -> Void)
    
    func fetchTakes(challengeId: String, completionHandler: @escaping(_ takes: () throws -> [TakeDto]) -> Void)
    
    func voteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void)
    
    func unvoteForTake(takeId: String, completionHandler: @escaping (Bool) -> Void)
    
    func isChallengeExpired(challengeId: String, completionHandler: @escaping (Bool) -> Void)
    
    func doesTakeExist(forChallenge challengeId: String, completionHandler: @escaping (Bool) -> Void)
}
