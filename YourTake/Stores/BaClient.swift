/**
 * Copyright (c) 2016 Enovi Inc.
 *
 * All rights reserved. Unauthorized reproduction or distribution of this file, via any medium, in
 * whole or in part, is strictly prohibited except by express written permission of Enovi Inc.
 */

/**
 * @author Olivier Thomas
 */

protocol BaClient {
    func Register(username: String, password: String) -> Bool
    func Login(username: String, password: String) -> Bool
    func ChangePassword(oldPassword: String, newPassword: String) -> Bool
    func ResetPassword(username: String) -> Bool

    func AddFriend(username: String) -> Bool
    func RemoveFriend(username: String) -> Bool

    func CreateChallenge(challenge: Challenge) -> Bool
    func RemoveChallenge(id: String) -> Bool

    func CreateTake(take: Take) -> Bool
    func RemoveTake(id: String) -> Bool

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
