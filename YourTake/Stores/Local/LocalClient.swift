//
//  LocalClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

class LocalClient: BaClient {
    var currentUser: User?
    var challenges: [Challenge]?
    var takes: [Take]?
    
    func Register(username: String, password: String) -> Bool {
        return false
    }
    
    func Login(username: String, password: String) -> Bool {
        return false
    }
    
    func ChangePassword(oldPassword: String, newPassword: String) -> Bool {
        return false
    }
    
    func ResetPassword(username: String) -> Bool {
        return false
    }
    
    func AddFriend(username: String) -> Bool {
        return false
    }
    
    func RemoveFriend(username: String) -> Bool {
        return false
    }
    
    func CreateChallenge(challenge: Challenge) -> Bool {
        return false
    }
    
    func RemoveChallenge(id: String) -> Bool {
        return false
    }
    
    func CreateTake(take: Take) -> Bool {
        return false
    }
    
    func RemoveTake(id: String) -> Bool {
        return false
    }
    
    func GetUser(username: String) -> User? {
        return nil
    }
    
    func GetUserFriends(username: String) -> [User]? {
        return nil
    }
    
    func GetUserChallenges(username: String) -> [Challenge]? {
        return nil
    }
    
    func GetUserTakes(username: String) -> [Take]? {
        return nil
    }
    
    func GetChallenge(id: String) -> Challenge? {
        return nil
    }
    
    func GetChallengeTakes(id: String) -> [Take]? {
        return nil
    }
    
    func GetTake(id: String) -> Take? {
        return nil
    }
    
    func GetTakeChallenge(id: String) -> Challenge? {
        return nil
    }
    
    func VoteTake(id: String) -> Bool {
        return false
    }
    
    func UnvoteTake(id: String) -> Bool {
        return false
    }
}
