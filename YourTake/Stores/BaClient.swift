/**
 * Copyright (c) 2016 Enovi Inc.
 *
 * All rights reserved. The methods and techniques described herein are considered 
 * trade secrets and/or confidential. Reproduction or distribution, in whole or in 
 * part, is forbidden except by express written permission of Enovi Inc.
 **/

/**
 * @author Olivier Thomas
 */

protocol BaClient {
    func Register(username: String, password: String) -> Bool
    func Login(username: String, password: String) -> Bool
    func ChangePassword(oldPassword: String, newPassword: String) -> Bool
    func ResetPassword(username: String) -> Bool

    func AddFriend(username: String)
    func RemoveFriend(username: String)

    func CreateChallenge(challenge: Challenge) -> Bool
    func RemoveChallenge(id: String)

    func CreateTake(take: Take) -> Bool
    func RemoveTake(id: String)

    func GetUser(username: String) -> User
    func GetUserFriends(username: String) -> [User]
    func GetUserChallenges(username: String) -> [Challenge]
    func GetUserTakes(username: String) -> [Take]

    func GetChallenge(id: String) -> Challenge
    func GetChallengeTakes(id: String) -> [Take]

    func GetTake(id: String) -> Take
    func GetTakeChallenge(id: String) -> Challenge

    func VoteTake(id: String) -> Bool
    func UnvoteTake(id: String) -> Bool
}
