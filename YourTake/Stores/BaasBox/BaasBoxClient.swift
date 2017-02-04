//
//  BaasBoxClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

class BaasBoxClient: BaClient {
    let client = BAAClient.shared()!

    init() {
        BaasBox.setBaseURL("http://192.168.0.18:9000", appCode: "1234567890")
    }

    func register(username: String, password: String, email: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if username.isEmpty || password.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        client.createUser(withUsername: username, password: password, completion: { (success, error) -> Void in
            if success {
                self.client.authenticateUser(username, password: password, completion: { (success, error) -> Void in
                    if success {
                        self.client.saveUser(toDisk: self.client.currentUser)
                        
                        var params = [String: Any]()
                        params["email"] = email
                        let baasUser = BaasBoxUser(dictionary: params)
                        
                        self.client.createObject(baasUser, completion: { (object, error) -> Void in
                            if object != nil {
                                completion(true)
                            } else {
                                print("error: unable to create user [description=\(error?.localizedDescription)]")
                                completion(false)
                            }
                        })
                    } else {
                        print("error: unable to login [description=\(error?.localizedDescription)]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to register [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }

    func login(username: String, password: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        client.authenticateUser(username, password: password, completion: { (success, error) -> Void in
            if error != nil {
                print("error: unable to login [description=\(error?.localizedDescription)]")
            } else {
                self.client.saveUser(toDisk: self.client.currentUser)
            }
            completion(success)
        })
    }

    func changePassword(oldPassword: String, newPassword: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if oldPassword.isEmpty || newPassword.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
    
        client.changeOldPassword(oldPassword, toNewPassword: newPassword, completion: { (success, error) -> Void in
            if error != nil {
                print("error: unable to change password [description=\(error?.localizedDescription)]")
            }
            completion(success)
        })
    }

    func resetPassword(for username: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if username.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        // try username
        client.resetPassword(forUser: username, withCompletion: { (success, error) -> () in
            if success {
                completion(true)
                return
            } else {
                print("info: unable to reset password with username trying with email")
                
                // try email
                let params = ["email": "\(username)", "recordsPerPage": "1"]
                BAAObject.getObjectsWithParams(params, completion: { (objects, error) -> Void in
                    if objects != nil {
                        if let baasUser = (objects as! [BaasBoxUser]).first {
                            self.client.resetPassword(forUser: baasUser.author, withCompletion: { (success, error) -> () in
                                if error != nil {
                                    print("error: unable to reset password [description=\(error?.localizedDescription)]")
                                }
                                completion(success)
                                return
                            })
                        }
                    } else {
                        print("error: unable to load user details [description=\(error?.localizedDescription)]")
                    }
                    completion(false)
                    return
                })
            }
        })
    }
    
    func getUser(completion: @escaping BaUserCompletionBlock) -> Void {
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(nil)
            return
        }
        
        let params = ["author": "\(client.currentUser.username()!)"]
        BaasBoxUser.getObjectsWithParams(params, completion: { (objects, error) -> Void in
            if let baasUser = (objects as? [BaasBoxUser])?.first {
                self.getFriends(completion: { (friends) -> Void in
                    completion(User(
                        username: self.client.currentUser.username(),
                        friends: friends,
                        votes: baasUser.votes))
                })
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
                completion(nil)
            }
        })
    }
    
    func getFriends(completion: @escaping BaStringsCompletionBlock) -> Void {
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([String]())
            return
        }
        
        client.loadFollowers(of: client.currentUser, completion: { (objects, error) -> Void in
            var friends = [String]()
            if let users = objects as? [BAAUser] {
                for user in users {
                    friends.append(user.username())
                }
            } else {
                print("error: unable to get friends [description=\(error?.localizedDescription)]")
            }
            completion(friends)
        })
    }

    func addFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if username.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        client.loadUsersDetails(username, completion: { (object, error) -> Void in
            if let friend = object as? BAAUser {
                self.client.follow(friend, completion: { (object, error) -> Void in
                    if object != nil {
                        completion(true)
                    } else {
                        print("error: unable to add friend [description=\(error?.localizedDescription)]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to find friend [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }

    func removeFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if username.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        client.loadUsersDetails(username, completion: { (object, error) -> Void in
            if let friend = object as? BAAUser {
                self.client.unfollowUser(friend, completion: { (success, error) -> Void in
                    if error != nil {
                        print("error: unable to remove friend [description=\(error?.localizedDescription)]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
    
    func getChallenge(with id: String, completion: @escaping BaChallengeCompletionBlock) -> Void {
        if id.isEmpty {
            print("error: invalid parameters")
            completion(nil)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(nil)
            return
        }
        
        BaasBoxChallenge.getWithId(id, completion: { (object, error) -> Void in
            if let baasChallenge = object as? BaasBoxChallenge {
                completion(Challenge(
                    id: baasChallenge.objectId,
                    author: baasChallenge.author,
                    image: baasChallenge.image!,
                    recipients: baasChallenge.recipients,
                    duration: Date(timeIntervalSinceNow: baasChallenge.durationHrs)))
            } else {
                print("error: unable to load user details [description=\(error?.localizedDescription)]")
                completion(nil)
            }
        })
    }
    
    func getChallenges(for friends: Bool, completion: @escaping BaChallengesCompletionBlock) -> Void {
        return getChallenges(to: Date(), with: 10, for: friends, completion: completion)
    }
    
    func getChallenges(to date: Date, with maxCount: UInt, for friends: Bool, completion: @escaping BaChallengesCompletionBlock) -> Void {
        if date > Date() || maxCount == 0 {
            print("error: invalid parameters")
            completion([Challenge]())
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([Challenge]())
            return
        }
        
        let baasObject = BaasBoxChallenge()
        var params = ["orderBy": "_creation_date",
                      "recordsPerPage": "\(maxCount)",
                      "where": "_creation_date<=\(BaasBox.dateFormatter()!.string(from: date))"]
        
        if friends {
            params["where"] = "\(params["where"]!)&author!=\(client.currentUser.username()!)"
        } else {
            params["where"] = "\(params["where"]!)&author==\(client.currentUser.username()!)"
        }
        
        client.loadCollection(baasObject, withParams: params, completion: { (objects, error) -> Void in
            var challenges = [Challenge]()
            if let baasChallenges = objects as? [BaasBoxChallenge] {
                for baasChallenge in baasChallenges {
                    let challenge = Challenge(
                        id: baasChallenge.objectId,
                        author: baasChallenge.author,
                        image: baasChallenge.image!,
                        recipients: baasChallenge.recipients,
                        duration: Date(timeIntervalSinceNow: baasChallenge.durationHrs))
                    challenges.append(challenge)
                }
            } else {
                print("error: unable to add friend [description=\(error?.localizedDescription)]")
            }
            completion(challenges)
        })
    }

    func createChallenge(_ challenge: Challenge, completion: @escaping BaBoolCompletionBlock) -> Void {
        if !challenge.isValid() {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        var params = [String: Any]()
        params["image"] = challenge.image
        params["duration"] = challenge.duration.timeIntervalSinceNow
        params["recipients"] = challenge.recipients
        let baasChallenge = BaasBoxChallenge(dictionary: params)
        
        client.createObject(baasChallenge, completion: { (object, error) -> Void in
            if object != nil {
                completion(true)
            } else {
                print("error: unable to create challenge [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }

    func removeChallenge(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if id.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        BaasBoxChallenge.getWithId(id, completion: { (object, error) -> Void in
            if let baasChallenge = object as? BaasBoxChallenge {
                baasChallenge.delete(completion: { (success, error) -> Void in
                    if error != nil {
                        print("error: unable to remove challenge [description=\(error?.localizedDescription)]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to load challenge [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
    
    func getTake(with id: String, completion: @escaping BaTakeCompletionBlock) -> Void {
        if id.isEmpty {
            print("error: invalid parameters")
            completion(nil)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(nil)
            return
        }
        
        BaasBoxTake.getWithId(id, completion: { (object, error) -> Void in
            if let baasTake = object as? BaasBoxTake {
                completion(Take(
                    id: baasTake.objectId,
                    challengeId: baasTake.challengeId,
                    author: baasTake.author,
                    overlay: baasTake.overlay!,
                    votes: baasTake.votes))
            } else {
                print("error: unable to load take [description=\(error?.localizedDescription)]")
                completion(nil)
            }
        })
    }

    func getTakes(for challengeId: String, completion: @escaping BaTakesCompletionBlock) -> Void{
        if challengeId.isEmpty {
            print("error: invalid parameters")
            completion([Take]())
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([Take]())
            return
        }
        
        let baasObject = BaasBoxTake(dictionary: [String: Any]())
        let params = ["page": "0",
                      "recordsPerPage": "50",
                      "orderBy": "votes"]
        client.loadCollection(baasObject, withParams: params, completion: { (objects, error) -> Void in
            var takes = [Take]()
            if let baasTakes = objects as? [BaasBoxTake] {
                for baasTake in baasTakes {
                    let take = Take(
                        id: baasTake.objectId,
                        challengeId: baasTake.challengeId,
                        author: baasTake.author,
                        overlay: baasTake.overlay!,
                        votes: baasTake.votes)
                    takes.append(take)
                }
            } else {
                print("error: unable to load takes [description=\(error?.localizedDescription)]")
            }
            completion(takes)
        })
    }
    
    func createTake(_ take: Take, completion: @escaping BaBoolCompletionBlock) -> Void {
        if take.isValid() {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        var params = [String: Any]()
        params["challengeId"] = take.challengeId
        params["overlay"] = take.overlay
        params["votes"] = take.votes
        let baasTake = BaasBoxTake(dictionary: params)
        
        client.createObject(baasTake, completion: { (object, error) -> Void in
            if object != nil {
                completion(true)
            } else {
                print("error: unable to create take [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
    
    func removeTake(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if id.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        BaasBoxTake.getWithId(id, completion: { (object, error) -> Void in
            if let baasTake = object as? BaasBoxTake {
                baasTake.delete(completion: { (success, error) -> Void in
                    if error != nil {
                        print("error: unable to remove take [description=\(error?.localizedDescription)]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to get challenge [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
    
    func vote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if takeId.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        BaasBoxTake.getWithId(takeId, completion: { (object, error) -> Void in
            if let baasTake = object as? BaasBoxTake {
                baasTake.votes += 1
                baasTake.save(completion: { (object, error) -> Void in
                    if object != nil {
                        completion(true)
                    } else {
                        print("error: unable to vote [description=\(error?.localizedDescription)]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to load take [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
    
    func unvote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        if takeId.isEmpty {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        BaasBoxTake.getWithId(takeId, completion: { (object, error) -> Void in
            if let baasTake = object as? BaasBoxTake {
                baasTake.votes -= 1
                baasTake.save(completion: { (object, error) -> Void in
                    if object != nil {
                        completion(true)
                    } else {
                        print("error: unable to unvote [description=\(error?.localizedDescription)]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to load take [description=\(error?.localizedDescription)]")
                completion(false)
            }
        })
    }
}
