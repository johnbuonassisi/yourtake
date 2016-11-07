//
//  Challenge.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class Challenge: NSObject {
    
    weak var owner : User?
    let image : UIImage
    let friends : [String]
    let expiryDate : NSDate
    
    private var voteTracker : VoteTracker
    var submissions = [Submission]()
    
    init(owner: User, image: UIImage, friends: [String], expiryDate: NSDate)
    {
        self.owner = owner
        self.image = image
        self.expiryDate = expiryDate
        self.friends = friends
        
        var allUsers = friends;
        allUsers.append(owner.name)
        self.voteTracker = VoteTracker(withUsers: allUsers)
    }
    
    func Submit(response: Submission)
    {
        submissions.append(response)
    }
    
    func voteFor(user: String, byVoter voter: String)
    {
        let test : Bool = voteTracker.vote(forUser: user, ByVoter: voter)
        // re-order the submissions
        submissions = submissions.sorted(by: {s1, s2 in return
           voteTracker.getNumVotes(forUser: s1.name) > voteTracker.getNumVotes(forUser: s2.name)})
    }
    
    func getNumberOfVotes(forUser user: String) -> Int
    {
        return voteTracker.getNumVotes(forUser: user)
    }
    
    func getTotalVotes() -> Int
    {
        var totalVotes : Int = 0
        for friend : String in friends
        {
            totalVotes += voteTracker.getNumVotes(forUser: friend)
        }
        return totalVotes
    }
    
    func getVoteOf(user : String) -> String?
    {
        return voteTracker.getVotedForUser(byVoter: user)
    }
    
    
}
