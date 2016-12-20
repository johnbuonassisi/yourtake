//
//  User.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class User: NSObject {
    
    
    let name : String
    let friends : [String]
    
    private var challenges = [Challenge]()
    private var expiredChallenges = [Challenge]()
    
    init(name: String, friends: [String]) {
        self.name = name;
        self.friends = friends;
    }
    
    func add(challenge: Challenge) {
        
        challenges.append(challenge)
        challenges = challenges.sorted(by:
                {c1, c2 in return c2.expiryDate as Date > c1.expiryDate as Date})
    }
    
    func getChallenge(_ index: Int) -> Challenge? {
        
        OrderExpiredChallenges()
        
        if index < challenges.count {
            return challenges[index]
        } else {
            let expiredChallengeIndex = index - challenges.count
            if expiredChallengeIndex < expiredChallenges.count {
                return expiredChallenges[expiredChallengeIndex]
            } else {
                return nil
            }
        }
    }
    
    func getChallenges() -> [Challenge]? {
        
        OrderExpiredChallenges()
        return challenges + expiredChallenges
    }
    
    func getNumChallenges() -> Int {
        
        return challenges.count + expiredChallenges.count
    }
    
    func getNumActiveChallenges() -> Int {
        return challenges.count
    }
    
    func getNumExpiredChallenges() -> Int {
        return expiredChallenges.count
    }
    
    private func OrderExpiredChallenges() {
        
        var numExpiredChallenges: Int = 0
        
        // Determine how many challenges have expired in the list
        let currentDate = Date()
        for challenge: Challenge in challenges {
            let result = challenge.expiryDate.compare(currentDate)
            if result == .orderedAscending {
                numExpiredChallenges += 1
            } else {
                break
            }
        }
        
        if numExpiredChallenges == 0 {
            return
        }
        
        // Remove expired challenges and put them into the expired challenge list
        for index in 0...numExpiredChallenges - 1 {
            expiredChallenges.append(challenges[index])
            challenges.remove(at: index)
        }
    }
}
