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
    var currentUser: BAAUser?

    init() {
        BaasBox.setBaseURL("http://192.168.1.100:9000", appCode: "5965980156")
    }

    func Register(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        client.createUser(withUsername: username, password: password, completion: { (success, error) -> Void in
            if (error == nil) {
                bSuccess = true
            } else {
                print("error: unable to register [description=\(error?.localizedDescription)]")
            }
        })

        return bSuccess
    }

    func Login(username: String, password: String) -> Bool {
        var bSuccess: Bool = false

        if client.isAuthenticated() {
            bSuccess = true
        } else {
            client.authenticateUser(username, password: password, completion: { (success, error) -> Void in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to login [description=\(error?.localizedDescription)]")
                }
            })
        }

        if (bSuccess) {
            currentUser = client.currentUser
        }

        return bSuccess
    }

    func ChangePassword(oldPassword: String, newPassword: String) -> Bool {
        var bSuccess: Bool = false

        if currentUser != nil {
            currentUser!.changeOldPassword(oldPassword, toNewPassword: newPassword, completionBlock: { (success, error) -> Void in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to change password [description=\(error?.localizedDescription)]")
                }
            })
        }

        return bSuccess
    }

    func ResetPassword(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser?

        BAAUser.loadDetails(username, completion: { (object, error) -> Void in
            if (error == nil) {
                targetUser = object as? BAAUser
                bSuccess = true
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
            }
        })

        if targetUser != nil {
            client.resetPassword(for: targetUser!, withCompletion: { (success, error) -> () in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to reset password [description=\(error?.localizedDescription)]")
                }
            })
        }

        return bSuccess
    }

    func AddFriend(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser?

        BAAUser.loadDetails(username, completion: { (object, error) -> Void in
            if (error == nil) {
                targetUser = object as? BAAUser
                bSuccess = true
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
            }
        })

        if targetUser != nil {
            client.follow(targetUser!, completion: { (object, error) -> Void in
                if error == nil {
                    bSuccess = true
                } else {
                    print("error: unable to add friend [description=\(error?.localizedDescription)]")
                }
            })
        }

        return bSuccess
    }

    func RemoveFriend(username: String) -> Bool {
        var bSuccess: Bool = false
        var targetUser: BAAUser?

        BAAUser.loadDetails(username, completion: { (object, error) -> Void in
            if (error == nil) {
                targetUser = object as? BAAUser
                bSuccess = true
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
            }
        })

        if targetUser != nil {
            client.unfollowUser(targetUser!, completion: { (success, error) -> Void in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to remove friend [description=\(error?.localizedDescription)]")
                }
            })
        }

        return bSuccess
    }

    func CreateChallenge(challenge: Challenge) -> Bool {
        var bSuccess: Bool = false
        
        var data = [String: Any]()
        data["photo"] = challenge.image
        data["duration"] = 24
        data["users"] = challenge.friends
        let baasChallenge = BaasBoxChallenge(data: data)
        
        client.createObject(baasChallenge, completion: { (object, error) -> Void in
            if (error == nil) {
                bSuccess = true
            } else {
                print("error: unable to create challenge [description=\(error?.localizedDescription)]")
            }
        })

        return bSuccess
    }

    func RemoveChallenge(id: String) -> Bool {
        var bSuccess: Bool = false

        var baasChallenge: BaasBoxChallenge?
        BAAObject.getWithId(id, completion: { (object, error) -> Void in
            if (error == nil) {
                baasChallenge = object as! BaasBoxChallenge?
                bSuccess = true
            } else {
                print("error: unable to get challenge [description=\(error?.localizedDescription)]")
            }
        })

        if baasChallenge != nil {
            baasChallenge!.delete(completion: { (success, error) -> Void in
                if (error == nil) {
                    bSuccess = true
                } else {
                    print("error: unable to remove challenge [description=\(error?.localizedDescription)]")
                }
            })
        }

        return bSuccess
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
