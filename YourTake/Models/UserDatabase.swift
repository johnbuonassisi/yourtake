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
        let john = User(name: "John", friends: johnsFriends)
        
        let johnsChallengeImage : UIImage = UIImage(named: "John_Challenge.jpg", in: nil, compatibleWith: nil)!
        let johnsChallengeImage2 : UIImage = UIImage(named: "John_Challenge_2.jpg", in: nil, compatibleWith: nil)!
        let ashlingsResponse : UIImage = UIImage(named: "John_Challenge_Ashling.jpg", in: nil, compatibleWith: nil)!
        let petersResponse : UIImage = UIImage(named: "John_Challenge_Peter.jpg", in: nil, compatibleWith: nil)!
        let andreasResponse : UIImage = UIImage(named: "John_Challenge_Andrea.jpg", in: nil, compatibleWith: nil)!
        let anthonysResponse : UIImage = UIImage(named: "John_Challenge_Anthony.jpg", in: nil, compatibleWith: nil)!
        
        john.challenges = [Challenge.init(owner: john, image: johnsChallengeImage, friends: johnsFriends),
                           Challenge.init(owner: john, image: johnsChallengeImage2, friends: johnsFriends)]
        john.challenges![0].submissions = [ashlingsResponse,
                                           petersResponse,
                                           andreasResponse,
                                           anthonysResponse];
        
        users = [john,
                 User.init(name: "Ashling", friends: ["John", "Peter", "Andrea", "Anthony"]),
                 User.init(name: "Peter", friends: ["John", "Ashling", "Andrea", "Anthony"]),
                 User.init(name: "Andrea", friends: ["John", "Ashling", "Peter", "Anthony"]),
                 User.init(name: "Anthony", friends: ["John", "Ashling", "Peter", "Andrea"])];
    }
    
    func John() -> User
    {
        return users[0]
    }
    
}
