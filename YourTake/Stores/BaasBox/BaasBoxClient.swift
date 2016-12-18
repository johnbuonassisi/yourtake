/**
 * Copyright (c) 2016 Enovi Inc.
 *
 * All rights reserved. Unauthorized reproduction or distribution of this file, via any medium, in
 * whole or in part, is strictly prohibited except by express written permission of Enovi Inc.
 */

/**
 * @author Olivier Thomas
 */

class BaasBoxClient: BaClient {
    let client = BAAClient.shared()!
    var currentUser: BAAUser

    init() {
        BaasBox.setBaseURL("http://192.168.1.100:9000", appCode: "5965980156")
    }

    func Register(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        client.createUser(withUsername: username, password: password, completion: { (success, error) -> Void in
            bSuccess = success
        })

        return bSuccess
    }

    func Login(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        if client.isAuthenticated() {
            bSuccess = true
        } else {
            client.authenticateUser(username, password: password, completion: { (success, error) -> Void in
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

        currentUser.changeOldPassword(oldPassword, toNewPassword: newPassword, completionBlock: { (success, error) -> Void in
            bSuccess = success
        })

        return bSuccess
    }

    func ResetPassword(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser

        BAAUser.loadDetails(username, completion: { (object, error) -> Void in
            targetUser = object as! BAAUser
        })

        client.resetPassword(for: targetUser, withCompletion: { (success, error) -> () in
            bSuccess = success
        })

        return bSuccess
    }

    func AddFriend(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser

        BAAUser.loadDetails(username, completion: { (object, error) -> Void in
            targetUser = object as! BAAUser
        })

        client.follow(targetUser, completion: { (object, error) -> Void in
            if (object != nil) {
                bSuccess = true
            }
        })

        return bSuccess
    }

    func RemoveFriend(username: String) -> Bool {
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
    
    func CreateTake(take: Take) -> Bool {}
    
    func RemoveTake(id: String) -> Bool {}
    
    func GetUser(username: String) -> User {}
    
    func GetUserFriends(username: String) -> [User] {}
    
    func GetUserChallenges(username: String) -> [Challenge] {}
    
    func GetUserTakes(username: String) -> [Take] {}
    
    func GetChallenge(id: String) -> Challenge {}
    
    func GetChallengeTakes(id: String) -> [Take] {}
    
    func GetTake(id: String) -> Take {}
    
    func GetTakeChallenge(id: String) -> Challenge {}
    
    func VoteTake(id: String) -> Bool {}
    
    func UnvoteTake(id: String) -> Bool {}
}
