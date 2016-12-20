//
//  BaClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

protocol BaClient {
    // admin
    func Register(username: String, password: String) -> Bool
    func Login(username: String, password: String) -> Bool
    func ChangePassword(oldPassword: String, newPassword: String) -> Bool
    func ResetPassword(username: String) -> Bool

    // friends
    func GetFriends() -> [String]?
    func AddFriend(username: String) -> Bool
    func RemoveFriend(username: String) -> Bool

    // challenges
    func GetChallenge(id: String) -> Challenge?
    func GetChallengeTakes(id: String) -> [Take]?
    func CreateChallenge(challenge: Challenge) -> Bool
    func RemoveChallenge(id: String) -> Bool

    // takes
    func GetTake(id: String) -> Take?
    func GetTakeChallenge(id: String) -> Challenge?
    func CreateTake(take: Take) -> Bool
    func RemoveTake(id: String) -> Bool

    // users
    func GetUser(username: String) -> User?
    func GetUserFriends(username: String) -> [String]?
    func GetUserChallenges(username: String) -> [Challenge]?
    func GetUserTakes(username: String) -> [Take]?

    // vote
    func VoteTake(id: String) -> Bool
    func UnvoteTake(id: String) -> Bool
}
