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

protocol BaasClient {
    
    func Register(username: String, password: String) -> Bool
    func Login(username: String, password: String) -> Bool
    func ChangePassword(oldPassword: String, newPassword: String) -> Bool
    func ResetPassword(username: String) -> Bool

    /*
    func AddFriend(username: String)
    func RemoveFriend(username: String)

    func CreateChallenge(challengeCfg: ChallengeCfg) -> String
    func RemoveChallenge(challengeId: String)

    func CreateTake(takeCfg: TakeCfg) -> String
    func RemoveTake(takeId: String)

    func GetUserInfo(username: String) -> UserInfo
    func GetUserTakes(username: String) -> [Take]
    func GetUserChallenges(username: String) -> [Challenge]

    func GetChallengeInfo(challengeId: String) -> ChallengeInfo
    func GetChallengeTake(challengeId: String) -> Take

    func GetTakeInfo(takeId: String) -> TakeInfo
    func GetTakeChallenges(takeId: String) -> Take
    
    func VoteTake(takeCfg: TakeCfg) -> String
    func UnvoteTake(takeId: String)
    */
}
