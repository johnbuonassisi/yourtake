//
//  BaasBoxClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

class BaasBoxClient: BaClient {
    let client: BAAClient = {
        
        // Get the BaasBox Base URL and App Code from BaasBoxConfig.plist
        var configDictionary: NSDictionary?
        if let configPath = Bundle.main.path(forResource: "BaasBoxConfig", ofType: "plist") {
            configDictionary = NSDictionary(contentsOfFile: configPath)
        }
        var baseUrl: NSString?
        var appCode: NSString?
        if let configDictionary = configDictionary {
            baseUrl = configDictionary.value(forKey: "BaasBox Base URL") as? NSString
            appCode = configDictionary.value(forKey: "BaasBox App Code") as? NSString
        }
        
        if let baseUrl = baseUrl, let appCode = appCode {
            BaasBox.setBaseURL(baseUrl as String,
                               appCode: appCode as String)
        } else {
            // Set to local default if unable to find base url and appcode keys
            BaasBox.setBaseURL("http://192.168.0.10:9000", appCode: "1234567890")
        }
        
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
                                print("error: unable to create user [description=\(String(describing: error?.localizedDescription))]")
                                completion(false)
                            }
                        })
                    } else {
                        print("error: unable to login [description=\(String(describing: error?.localizedDescription))]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to register [description=\(String(describing: error?.localizedDescription))]")
                completion(false)
            }
        })
    }

    func login(username: String, password: String, completion: @escaping BaBoolCompletionBlock) -> Void {
        client.authenticateUser(username, password: password, completion: { (success, error) -> Void in
            if error != nil {
                print("error: unable to login [description=\(String(describing: error?.localizedDescription))]")
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
                print("error: unable to change password [description=\(String(describing: error?.localizedDescription))]")
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
                                    print("error: unable to reset password [description=\(String(describing: error?.localizedDescription))]")
                                }
                                completion(success)
                                return
                            })
                        }
                    } else {
                        print("error: unable to load user details [description=\(String(describing: error?.localizedDescription))]")
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
    
    func getCurrentUserName() -> String {
        return client.currentUser.username()
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
                self.getFollowing(completion: { (friends) -> Void in
                    if let friends = friends {
                        completion(User(
                            username: self.client.currentUser.username(),
                            friends: friends,
                            votes: baasUser.votes))
                    } else {
                        print("error: unable to load user details because unable to fetch following")
                        completion(nil)
                    }
                })
            } else {
                print("error: unable to load user details [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
        })
    }
    
    func getFollowing(completion: @escaping BaStringsOptionalCompletionBlock) -> Void {
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
                print("error: unable to get following [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
            completion(friends)
        })
    }
    
    func getFollowers(completion: @escaping BaStringsOptionalCompletionBlock) -> Void {
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([String]())
            return
        }
        
        client.loadFollowers(of: client.currentUser, completion: { (objects, error) in
            var followers = [String]()
            if let users = objects as? [BAAUser] {
                for follower in users {
                    followers.append(follower.username())
                }
            } else {
                print("error: unable to get followers [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
            completion(followers)
        })
    }
    
    func getUsers(completion: @escaping BaStringsOptionalCompletionBlock) -> Void {
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion([String]())
            return
        }
        
        client.loadUsers( completion: { (objects, error) in
            var users = [String]()
            if let baasUsers = objects as? [BAAUser] {
                for user in baasUsers {
                    users.append(user.username())
                }
            } else {
                print("error: unable to get users [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
            users = users.filter{ $0 != self.client.currentUser.username() }
            completion(users)
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
                        print("error: unable to add friend [description=\(String(describing: error?.localizedDescription))]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to find friend [description=\(String(describing: error?.localizedDescription))]")
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
                        print("error: unable to remove friend [description=\(String(describing: error?.localizedDescription))]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to load user details [description=\(String(describing: error?.localizedDescription))]")
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
                print("error: unable to load challenge [description=\(String(describing: error?.localizedDescription))]")
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
                print("error: unable to load challenges [description=\(String(describing: error?.localizedDescription))]")
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
                let params = ["id": challengeId,
                              "imageId": baasFile.fileId,
                              "duration": challenge.duration,
                              "recipients": challenge.recipients] as [String : Any]
                
                let baasChallenge = BaasBoxChallenge(dictionary: params)
                self.client.createObject(baasChallenge, completion: { (object, error) -> Void in
                    if let baasChallenge = object as? BaasBoxChallenge {
                        // WORK-AROUND: Grant read access to all friends of this user
                        // because this only takes a single network call and does not
                        // depend on the results of the last permission grant action
                        let friendsOfAuthorRole = "friends_of_" + self.client.currentUser.username()
                        baasChallenge.grantAccess(toRole: friendsOfAuthorRole, ofType: kAclReadPermission, completion: { (object, error) in
                            if error == nil {
                                print("Read access given to friends of \(self.client.currentUser.username()) for challenge \(challengeId)")
                                completion(true)
                            } else {
                                print("error: unable to give read access to friends of \(self.client.currentUser.username()) for challenge \(challengeId)")
                                print("[description=\(String(describing:error?.localizedDescription))]")
                                completion(false)
                            }
                        })
                        Backend.sharedInstance.challengesInProgress.remove(at: challengeIndex)
                    } else {
                        print("error: unable to create challenge [description=\(String(describing: error?.localizedDescription))]")
                        baasFile.delete(completion: nil)
                        Backend.sharedInstance.challengesInProgress.remove(at: challengeIndex)
                        completion(false)
                    }
                })
            } else {
                print("error: unable to create challenge [description=\(String(describing: error?.localizedDescription))]")
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
                        print("error: unable to remove challenge [description=\(String(describing: error?.localizedDescription))]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to load challenge [description=\(String(describing: error?.localizedDescription))]")
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
                print("error: unable to load take [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
        })
    }
    
    func getTakeDtoForCurrentUser(fromChallenge challengeId: String, completion: @escaping BaTakeDtoCompletionBlock) -> Void {
        if challengeId.isEmpty {
            print("error: invalid parameters")
            completion(nil)
            return
        }
        
        if client.currentUser == nil || !client.isAuthenticated() {
            print("error: user not authenticated")
            completion(nil)
            return
        }
        
        let userName = client.currentUser.username()!
        let params = ["where": "challengeId='" + challengeId + "' and _author='" + userName + "'"]
        BaasBoxTake.getObjectsWithParams(params) { (objects, error) in
            if let baasTakes = (objects as? [BaasBoxTake]) {
                if let baasTake = baasTakes.first {
                    completion(TakeDto(id: baasTake.objectId,
                                       challengeId: baasTake.challengeId,
                                       imageId: baasTake.overlayId,
                                       author: baasTake.author,
                                       votes: baasTake.votes))
                } else {
                    completion(nil)
                }
            } else {
                print("error: unable to load takes [description=\(String(describing: error?.localizedDescription))]")
                completion(nil)
            }
        }
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
                print("error: unable to load takes [description=\(String(describing: error?.localizedDescription))]")
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
                    // Need to nest the grant access calls because the version of the baasTake gets updated after each operation
                    // Trying to grant access to an old version of a baasTake causes an error
                    if let baasTake = object as? BaasBoxTake {
                        baasTake.grantAccess(toRole: kAclRegisteredRole,
                                             ofType: kAclReadPermission,
                                             completion: { (object, error) in
                            if let baasTake = object as? BaasBoxTake {
                                baasTake.grantAccess(toRole: kAclRegisteredRole,
                                                     ofType: kAclUpdatePermission,
                                                     completion: { (object, error) in
                                                        if object == nil {
                                                            print("error: unable to grant update permission to registered users for take \(baasTake.objectId)")
                                                            baasFile.delete(completion: nil)
                                                            Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                                                            completion(false)
                                                        }
                                                        Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                                                        completion(true)
                                })
                            } else {
                                print("error: unable to grant read access to registered users for take \(baasTake.objectId)")
                                baasFile.delete(completion: nil)
                                Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                                completion(false)
                            }
                        })
                    } else {
                        print("error: unable to create challenge [description=\(String(describing: error?.localizedDescription))]")
                        baasFile.delete(completion: nil)
                        Backend.sharedInstance.takesInProgress.remove(at: takeIndex)
                        completion(false)
                    }
                })
            } else {
                print("error: unable to create challenge [description=\(String(describing: error?.localizedDescription))]")
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
                        print("error: unable to remove take [description=\(String(describing: error?.localizedDescription))]")
                    }
                    completion(success)
                })
            } else {
                print("error: unable to get challenge [description=\(String(describing: error?.localizedDescription))]")
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
                                print("error: unable to load user details [description=\(String(describing: error?.localizedDescription))]")
                                self.unvote(with: takeId, completion: { _ in ()
                                    completion(false)
                                })
                            }
                        })
                    } else {
                        print("error: unable to vote [description=\(String(describing: error?.localizedDescription))]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to load take [description=\(String(describing: error?.localizedDescription))]")
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
                                print("error: unable to load user details [description=\(String(describing: error?.localizedDescription))]")
                                self.vote(with: takeId, completion: { _ in ()
                                    completion(false)
                                })
                            }
                        })
                    } else {
                        print("error: unable to unvote [description=\(String(describing: error?.localizedDescription))]")
                        completion(false)
                    }
                })
            } else {
                print("error: unable to load take [description=\(String(describing: error?.localizedDescription))]")
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
    
    func enablePushNotificationsForCurrentUser(token: Data, completion: @escaping BaBoolErrorCompletionBlock) {
        client.enablePushNotifications(token, completion: completion )
    }
    
    func disablePushNotificationsForCurrentUser(completion: @escaping BaBoolErrorCompletionBlock) {
        client.disablePushNotifications(completion: completion )
    }
    
    func sendPushNotification(username: String, message: String,
                              customPayload: [String: String]?,
                              completion: @escaping BaBoolErrorCompletionBlock) {
        print("Sending push notification to \(username)")
        client.pushNotification(toUsername: username,
                                withMessage: message,
                                customPayload: customPayload,
                                completion: completion)
    }
}
