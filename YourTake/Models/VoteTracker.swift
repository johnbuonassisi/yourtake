//
//  VoteTracker.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-05.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class VoteTracker: NSObject {
    
    private let users : [String]
    private var voterDictionary = [String : String]()
    private var numVotesDictionary = [String : Int]()
    
    init(withUsers users: [String])
    {
        self.users = users
    }
    
    func vote(forUser user: String, ByVoter voter: String) -> Bool
    {
        // Check that both users are in the user list
        if !users.contains(user) {
            print("The voted for user was not in the list")
            return false
        }
        if !users.contains(voter) {
            print("The voter is not in the list")
            return false
        }
        
        if let previousVotedForUser = voterDictionary[voter] {
            
            // voter has already voted for a user
            // decrement the number of votes for the previously voted for user
            let numVotesForUser = numVotesDictionary[previousVotedForUser]
            numVotesDictionary[previousVotedForUser] = numVotesForUser! - 1
            
            if(previousVotedForUser == user)
            {
                voterDictionary.removeValue(forKey: voter)
                return true
            }
            
        }
        
        // set and add to the votes of the voted for user
        voterDictionary[voter] = user
        addVote(forUser: user, ByVoter: voter)
        
        return true
    }
    
    func getNumVotes(forUser user: String) -> Int
    {
        if let numVotes = numVotesDictionary[user] {
            return numVotes
        }
        return 0
    }
    
    func getVotedForUser(byVoter voter: String) -> String?
    {
        return voterDictionary[voter]
        
    }
    
    private func addVote(forUser user: String, ByVoter voter: String)
    {
        if let numVotesForThisUser = numVotesDictionary[user] {
            numVotesDictionary[user] = numVotesForThisUser + 1
        }
        else {
            numVotesDictionary[user] = 1
        }
    }

}
