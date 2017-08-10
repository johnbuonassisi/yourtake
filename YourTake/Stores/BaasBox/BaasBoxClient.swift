//
//  BaasBoxClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

class BaasBoxClient: BaClient {
    let client: BAAClient = {
        BaasBox.setBaseURL("http://192.168.0.12:9000", appCode: "1234567890")
        return BAAClient.shared()!
    }()

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
    
    func getServerTime(completion: @escaping BaStringCompletionBlock) -> Void {
        completion("")
    }
    
    func getUser(completion: @escaping BaUserCompletionBlock) -> Void {
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(nil)
            return
        }
        
        let params = ["_author": "\(client.currentUser.username()!)"]
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
        
        client.loadFollowing(for: client.currentUser, completion: { (objects, error) -> Void in
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
    
    func getChallengeDto(with id: String, completion: @escaping BaChallengeDtoCompletionBlock) -> Void {
        
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
            if let baasChallenge = object as? BaasBoxChallenge
            {
                        completion(ChallengeDto(
                            id: baasChallenge.objectId,
                            author: baasChallenge.author,
                            imageId: baasChallenge.imageId,
                            recipients: baasChallenge.recipients,
                            duration: baasChallenge.duration,
                            created: baasChallenge.creationDate))
            } else {
                print("error: unable to load challenge [description=\(error?.localizedDescription)]")
                        completion(nil)
            }
        })
    }

    func getChallengeDtoList(for friends: Bool, completion: @escaping BaChallengeDtoListCompletionBlock) -> Void {
        return getChallengeDtoList(to: Date(), with: 10, for: friends, completion: completion)
    }
    
    func getChallengeDtoList(to date: Date, with maxCount: UInt, for friends: Bool, completion: @escaping BaChallengeDtoListCompletionBlock) -> Void {
        
        if date > Date() || maxCount == 0 {
            print("error: invalid parameters")
            completion([ChallengeDto]())
            return
        }
            
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([ChallengeDto]())
            return
        }
            
        let baasObject = BaasBoxChallenge()
        var params = ["recordsPerPage": "\(maxCount)"]
        
        if friends {
            params["where"] = "recipients in ?"
            params["params"] = "\(client.currentUser.username()!)"
        } else {
            params["where"] = "_author=?"
            params["params"] = "\(client.currentUser.username()!)"
        }
        
        client.loadCollection(baasObject, withParams: params, completion: { (objects, error) -> Void in
            var challenges = [ChallengeDto]()
            if let baasChallenges = objects as? [BaasBoxChallenge] {
            
                if !baasChallenges.isEmpty {
                    for baasChallenge in baasChallenges {
                        
                        let challenge = ChallengeDto(
                            id: baasChallenge.objectId,
                            author: baasChallenge.author,
                            imageId: baasChallenge.imageId,
                            recipients: baasChallenge.recipients,
                            duration: baasChallenge.duration,
                            created: baasChallenge.creationDate)
                        challenges.append(challenge)
                    }
                    challenges.sort(by: { (left, right) -> Bool in
                        if left.getTimeRemaining() > right.getTimeRemaining() {
                            return true
                        } else if left.created > right.created {
                            return true
                        }
                        return false
                    })
                    
                } else { // baasChallenges are empty
                    print("warn: no challenges available")
                    completion(challenges)
                }
            } else { // baasChallenges is null
                print("error: unable to load challenges [description=\(error?.localizedDescription)]")
                completion(challenges)
            }
            
            completion(challenges)
        })
    }
    
    func createChallenge(_ challenge: ChallengeDto, completion: @escaping BaBoolCompletionBlock) -> Void {
        
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
        
        let jpegData = UIImageJPEGRepresentation(challenge.image!, 0.25)
        let baasFileImage = BAAFile(data: jpegData)
        baasFileImage?.contentType = "image/jpeg"
        
        // set file permission
        var permissions = ["read": ["users": [String]()]]
        for recipient in challenge.recipients {
            permissions[kAclReadPermission]?["users"]?.append(recipient)
        }
        
        // generate unique challenge id and add to in-progress list
        let challengeId = UUID().uuidString.lowercased()
        Backend.sharedInstance.challengesInProgress.append(challengeId)
        let challengeIndex = Backend.sharedInstance.challengesInProgress.index(of: challengeId)!
        
        client.uploadFile(baasFileImage, withPermissions: permissions, completion: { (object, error) -> Void in
            if let baasFile = object as? BAAFile {
                var params = ["id": challengeId,
                              "imageId": baasFile.fileId,
                              "duration": challenge.duration,
                              "recipients": challenge.recipients] as [String : Any]
                
                let baasChallenge = BaasBoxChallenge(dictionary: params)
                self.client.createObject(baasChallenge, completion: { (object, error) -> Void in
                    if let baasChallenge = object as? BaasBoxChallenge {
                        // set challenge permission
                        for recipient in params["recipients"] as! [String] {
                            baasChallenge.grantAccess(toUser: recipient, ofType: kAclReadPermission, completion: nil)
                        }
                        Backend.sharedInstance.challengesInProgress.remove(at: challengeIndex)
                        completion(true)
                    } else {
                        print("error: unable to create challenge [description=\(error?.localizedDescription)]")
                        baasFile.delete(completion: nil)
                        Backend.sharedInstance.challengesInProgress.remove(at: challengeIndex)
                        completion(false)
                    }
                })
            } else {
                print("error: unable to create challenge [description=\(error?.localizedDescription)]")
                Backend.sharedInstance.challengesInProgress.remove(at: challengeIndex)
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
  
    
    func getTakeDto(with id: String, completion: @escaping BaTakeDtoCompletionBlock) -> Void {
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
                        completion(TakeDto(
                            id: baasTake.objectId,
                            challengeId: baasTake.challengeId,
                            imageId: baasTake.overlayId,
                            author: baasTake.author,
                            votes: baasTake.votes))
            } else {
                print("error: unable to load take [description=\(error?.localizedDescription)]")
                completion(nil)
            }
        })
    }
  
    func getTakeDtoList(for challengeId: String, completion: @escaping BaTakeDtoListCompletionBlock) -> Void{
        
        if challengeId.isEmpty {
            print("error: invalid parameters")
            completion([TakeDto]())
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([TakeDto]())
            return
        }
        
        let baasObject = BaasBoxTake()
        let params = ["recordsPerPage": "50",
                      "orderBy": "votes",
                      "where": "challengeId=?",
                      "params": challengeId]
        client.loadCollection(baasObject, withParams: params, completion: { (objects, error) -> Void in
            var takes = [TakeDto]()
            if let baasTakes = objects as? [BaasBoxTake] {
                if !baasTakes.isEmpty {
                    for baasTake in baasTakes {
                        let take = TakeDto(id: baasTake.objectId,
                                           challengeId: baasTake.challengeId,
                                           imageId: baasTake.overlayId,
                                           author: baasTake.author,
                                           votes: baasTake.votes)
                            takes.append(take)
                            if takes.count == baasTakes.count {
                                takes.sort(by: { (left, right) -> Bool in
                                    if left.votes > right.votes {
                                        return true
                                    }
                                    return false
                                })
                                completion(takes)
                        }
                    }
                } else {
                    print("info: no takes available for challengeId=\(challengeId)")
                    completion(takes)
                }
            } else {
                print("error: unable to load takes [description=\(error?.localizedDescription)]")
                completion(takes)
            }
        })
    }
    
    func createTake(_ take: TakeDto, completion: @escaping BaBoolCompletionBlock) -> Void {
        if !take.isValid() {
            print("error: invalid parameters")
            completion(false)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(false)
            return
        }
        
        let jpegData = UIImageJPEGRepresentation(take.overlay!, 0.25)
        let baasFileImage = BAAFile(data: jpegData)
        baasFileImage?.contentType = "image/jpeg"
        let permissions = [kAclReadPermission: ["roles": [kAclRegisteredRole]]]
        
        // generate unique take id and add to in-progress list
        let takeId = UUID().uuidString.lowercased()
        Backend.sharedInstance.takesInProgress.append(takeId)
        let takeIndex = Backend.sharedInstance.takesInProgress.index(of: takeId)!
        
        client.uploadFile(baasFileImage, withPermissions: permissions, completion: { (object, error) -> Void in
            if let baasFile = object as? BAAFile {
                let params = ["id": takeId,
                              "challengeId": take.challengeId,
                              "overlayId": baasFile.fileId,
                              "votes": take.votes] as [String : Any]
                
                let baasTake = BaasBoxTake(dictionary: params)
                self.client.createObject(baasTake, completion: { (object, error) -> Void in
                    if let baasTake = object as? BaasBoxTake {
                        baasTake.grantAccess(toRole: kAclRegisteredRole, ofType: kAclReadPermission, completion: nil)
                        baasTake.grantAccess(toRole: kAclRegisteredRole, ofType: kAclUpdatePermission, completion: nil)
                        Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                        completion(true)
                    } else {
                        print("error: unable to create challenge [description=\(error?.localizedDescription)]")
                        baasFile.delete(completion: nil)
                        Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                        completion(false)
                    }
                })
            } else {
                print("error: unable to create challenge [description=\(error?.localizedDescription)]")
                Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
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
                        let params = ["_author": "\(self.client.currentUser.username()!)"]
                        BaasBoxUser.getObjectsWithParams(params, completion: { (objects, error) -> Void in
                            if let baasUser = (objects as? [BaasBoxUser])?.first {
                                if let oldTakeId = baasUser.votes[baasTake.challengeId] {
                                    self.unvote(with: oldTakeId, completion: { _ in ()
                                        baasUser.votes[baasTake.challengeId] = takeId
                                        baasUser.save(completion: { _ in ()
                                            completion(true)
                                        })
                                    })
                                } else {
                                    baasUser.votes[baasTake.challengeId] = takeId
                                    baasUser.save(completion: { _ in ()
                                        completion(true)
                                    })
                                }
                            } else {
                                print("error: unable to load user details [description=\(error?.localizedDescription)]")
                                self.unvote(with: takeId, completion: { _ in ()
                                    completion(false)
                                })
                            }
                        })
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
                        let params = ["_author": "\(self.client.currentUser.username()!)"]
                        BaasBoxUser.getObjectsWithParams(params, completion: { (objects, error) -> Void in
                            if let baasUser = (objects as? [BaasBoxUser])?.first {
                                baasUser.votes.removeValue(forKey: baasTake.challengeId)
                                baasUser.save(completion: { _ in ()
                                    completion(true)
                                })
                            } else {
                                print("error: unable to load user details [description=\(error?.localizedDescription)]")
                                self.vote(with: takeId, completion: { _ in ()
                                    completion(false)
                                })
                            }
                        })
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
    
    func downloadImage(with id: String, completion: @escaping BaImageCompletionBlock) {
        
        var image: UIImage?
        BAAFile.load(withId: id, completion: { (object, error) in
            if object != nil {
                image = UIImage(data: object!)
            }
            completion(image)
        })
    }
}
