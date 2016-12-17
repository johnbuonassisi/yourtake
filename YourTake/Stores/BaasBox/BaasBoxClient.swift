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

class BaasBoxClient: BaClient {
    let client = BAAClient.sharedClient()
    var currentUser: BAAUser

    init() {
        BaasBox.setBaseURL("http://192.168.1.100:9000", appCode: "5965980156")
    }

    func Register(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        client.createUserWithUsername(username, password: password, completion: { (success: Bool, error: NSError!) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func Login(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        if client.isAuthenticated() {
            bSuccess = true
        } else {
            client.authenticateUser(username, password: password, completion: { (success: Bool, error: NSError!) -> () in
                bSuccess = success
            })
        }

        if (bSuccess) {
            currentUser = client.currentUser
        }

        return bSuccess
    }

    func ChangePassword(oldPassword: String, newPassword: String) -> Bool {
        var bSuccess: Bool = false

        currentUser.changeOldPassword(username, toNewPassword: password, completionBlock: { (success: Bool, error: NSError!) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func ResetPassword(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser

        targetUser.loadUserDetails(username, completion: { (user: BAAUser, error: NSError!) -> () in
            targetUser = user
        })

        client.resetPasswordForUser(targetUser, withCompletion: { (success: Bool, error: NSError!) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func AddFriend(username: String) {
        var bSuccess: Bool = false
        var targetUser: BAAUser

        targetUser.loadUserDetails(username, completion: { (user: BAAUser, error: NSError!) -> () in
            targetUser = user
        })

        client.followUser(targetUser, withCompletion: { (success: Bool, error: NSError!) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func RemoveFriend(username: String) {
        var bSuccess: Bool = false
        var targetUser: BAAUser

        targetUser.loadUserDetails(username, completion: { (user: BAAUser, error: NSError!) -> () in
            targetUser = user
        })

        client.unfollowUser(targetUser, withCompletion: { (success: Bool, error: NSError!) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func CreateChallenge(challenge: Challenge) -> Bool {
        var bSuccess: Bool = false

        var params: [NSObject: AnyObject]!
        params["photo"] = challenge.photo
        params["duration"] = challenge.durationHrs
        params["users"] = challenge.users

        let baasChallenge: BaasBoxChallenge = BaasBoxChallenge(params)

        var challengeId: id?
        currentUser.createObject(baasChallenge, completion: { (object: id, error: NSError!) -> () in
            if (error == nil) {
                challengeId = object
                bSuccess = true
            } else {
                // log error
            }
        })

        return bSuccess
    }

    func RemoveChallenge(id: String) -> Bool {
        var bSuccess: Bool = false

        var baasChallenge: BaasBoxChallenge?
        baasChallenge.getObjectWithId(id, completion: { (object: id, error: NSError!) -> () in
            if (error == nil) {
                bSuccess = true
            } else {
                print("error: unable to get challenge [code=\(error.code) domain=\(error.domain)]")
            }
        })

        if (bSuccess) {
            baasChallenge.deleteObjectWithCompletion({ (success: Bool, error: NSError!) -> () in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to remove challenge [code=\(error.code) domain=\(error.domain)]")
                }
            })
        }

        return bSuccess
    }

    func CreateTake(take: Take) -> String {}

    func RemoveTake(id: String) -> Bool {}

    func GetUser(username: String) -> User {}

    func GetUserFriends(username: String) -> [User] {}

    func GetUserTakes(username: String) -> [Take] {}

    func GetUserChallenges(username: String) -> [Challenge] {}

    func GetChallenge(id: String) -> Challenge {

    }

    func GetChallengeTakes(id: String) -> [Take] {}

    func GetTake(id: String) -> Take {}

    func GetTakeChallenge(id: String) -> Challenge {}

    func VoteTake(id: String) -> Bool {}

    func UnvoteTake(id: String) -> Bool {}
}