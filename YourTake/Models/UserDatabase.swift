//
//  UserDatabase.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class UserDatabase: NSObject {
    
    static let global : UserDatabase = UserDatabase()
    let users : [User]
    
    
    private override init()
    {
        let johnsFriends = ["Ashling", "Peter", "Andrea", "Anthony"]
        let ashlingsFriends = ["John", "Peter", "Andrea", "Anthony"]
        let john = User(name: "John", friends: johnsFriends)
        let ashling = User(name: "Ashling", friends: ashlingsFriends)
        
        // Init images associated with Johns Challenges
        let johnsChallengeImage : UIImage = UIImage(named: "John_Challenge.jpg", in: nil, compatibleWith: nil)!
        let johnsChallengeImage2 : UIImage = UIImage(named: "John_Challenge_2.jpg", in: nil, compatibleWith: nil)!
        let ashlingsResponse : UIImage = UIImage(named: "John_Challenge_Ashling.jpg", in: nil, compatibleWith: nil)!
        let petersResponse : UIImage = UIImage(named: "John_Challenge_Peter.jpg", in: nil, compatibleWith: nil)!
        let andreasResponse : UIImage = UIImage(named: "John_Challenge_Andrea.jpg", in: nil, compatibleWith: nil)!
        let anthonysResponse : UIImage = UIImage(named: "John_Challenge_Anthony.jpg", in: nil, compatibleWith: nil)!
        
        // Init images associated with Ashlings Challenges
        let ashlingsChallengeImage : UIImage = UIImage(named: "Ashling_Challenge.jpg", in: nil, compatibleWith: nil)!
        let johnsResponse2 : UIImage = UIImage(named: "Ashling_Challenge_John.jpg", in: nil, compatibleWith: nil)!
        let petersResponse2 : UIImage = UIImage(named: "Ashling_Challenge_Peter.jpg", in: nil, compatibleWith: nil)!
        let andreasResponse2 : UIImage = UIImage(named: "Ashling_Challenge_Andrea.jpg", in: nil, compatibleWith: nil)!
        let anthonysResponse2 : UIImage = UIImage(named: "Ashling_Challenge_Anthony.jpg", in: nil, compatibleWith: nil)!
        
        // Set expiry for 1 hour from current time
        let challengeExpiryDate1 = NSDate(timeIntervalSinceNow: 60*60)
        // Set expiry for 1 day from current time
        let challengeExpiryDate2 = NSDate(timeIntervalSinceNow: 25*60*60)
        // Set expiry for 10 minutes from the current time
        let challengeExpiryDate3 = NSDate(timeIntervalSinceNow: 10*60)
        
        // Add johns challenges: They array that stores the challenges will be sorted
        // by expiryDate on insertion
        john.add(challenge: Challenge.init(owner: john,
                                           image: johnsChallengeImage,
                                           friends: johnsFriends,
                                           expiryDate: challengeExpiryDate1))
        john.add(challenge: Challenge.init(owner: john,
                                           image: johnsChallengeImage2,
                                           friends: johnsFriends,
                                           expiryDate: challengeExpiryDate2))
        
        // Add ashlings challenges
        ashling.add(challenge: Challenge(owner: ashling,
                                         image: ashlingsChallengeImage,
                                         friends: ashlingsFriends,
                                         expiryDate: challengeExpiryDate3))
        
        
        // Add takes and votes to Johns Challenges
        john.challenges![0].takes = [Take(image: ashlingsResponse, name: "Ashling"),
                                           Take(image: petersResponse, name: "Peter"),
                                           Take(image: andreasResponse, name: "Andrea"),
                                           Take(image: anthonysResponse, name: "Anthony")];
        
        john.challenges![0].voteFor(user: "Anthony", byVoter: "Peter")
        john.challenges![0].voteFor(user: "Anthony", byVoter: "Andrea")
        john.challenges![0].voteFor(user: "Andrea", byVoter: "Ashling")
        john.challenges![0].voteFor(user: "Peter", byVoter: "Anthony")
        
        // Add takes and votes to Ashlings Challenges
        ashling.challenges![0].takes = [Take(image: johnsResponse2, name: "John"),
                                              Take(image: petersResponse2, name: "Peter"),
                                              Take(image: andreasResponse2, name: "Andrea"),
                                              Take(image: anthonysResponse2, name: "Anthony")]
        
        ashling.challenges![0].voteFor(user: "Peter", byVoter: "Andrea")
        ashling.challenges![0].voteFor(user: "Peter", byVoter: "Anthony")
        ashling.challenges![0].voteFor(user: "John", byVoter: "Peter")
        ashling.challenges![0].voteFor(user: "Anthony", byVoter: "John")
        
        
        users = [john,
                 ashling,
                 User.init(name: "Peter", friends: ["John", "Ashling", "Andrea", "Anthony"]),
                 User.init(name: "Andrea", friends: ["John", "Ashling", "Peter", "Anthony"]),
                 User.init(name: "Anthony", friends: ["John", "Ashling", "Peter", "Andrea"])];
    }
    
    func John() -> User
    {
        return users[0]
    }
    
    func GetUser(_ userName: String) -> User?
    {
        for user : User in users
        {
            if(user.name == userName)
            {
                return user
            }
        }
        return nil
    }
    
    func GetFriendChallenge(forUserWithName userName : String, atIndex index: Int) -> Challenge?
    {
        
        let friendChallengeList : [Challenge]? = GetFriendChallengeList(forUserWithName: userName)
        if friendChallengeList == nil {
            return nil
        }
        return friendChallengeList?[index]
    }
    
    func GetNumberOfFriendChallenges(forUserWithName userName: String) -> Int
    {
        let friendChallengeList : [Challenge]? = GetFriendChallengeList(forUserWithName: userName)
        if friendChallengeList == nil {
            return 0
        }
        return friendChallengeList!.count
    }
    
    private func GetFriendChallengeList(forUserWithName userName: String) -> [Challenge]?
    {
        // Define a list of friend challenges
        var friendChallengeList : [Challenge]?
        // For each of the users friends
        let currentUser = GetUser(userName)
        for friend : String in currentUser!.friends
        {
            // If the friend has challenges
            let friendUser = GetUser(friend)
            if friendUser!.challenges != nil
            {
                // For each of the friends challenges
                for friendChallenge : Challenge in friendUser!.challenges!
                {
                    // If the challenge was shared with the user with userName
                    if(friendChallenge.friends.contains(userName))
                    {
                        if friendChallengeList == nil {
                            friendChallengeList = [Challenge]()
                        }
                        // Add this challenge to a challenge list
                        friendChallengeList!.append(friendChallenge)
                    }
                }
            }
        }
        
        // Re-order the list so that the most recent challenges are at the top
        friendChallengeList?.sort(by: {fc1, fc2 in return fc2.expiryDate as Date > fc1.expiryDate as Date})
        return friendChallengeList
    }
    
}
