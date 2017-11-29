//
//  FriendsBaasBoxStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-11.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendsBaasBoxStore: FriendsStoreProtocol {
    
    func getFriends(completion: @escaping ([String]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFollowing(completion: completion)
    }
    
    func getNumberOfFriends(completion: @escaping (Int) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFollowing(completion: {(friends) -> Void in
            completion(friends.count)
        })
    }
    
    func getFollowing(completion: @escaping ([String]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFollowing(completion: completion)
    }
    
    func getFollowers(completion: @escaping ([String]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFollowers(completion: completion)
    }
    
    func getUsers(completion: @escaping ([String]) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getUsers(completion: completion)
    }
    
    func followUser(userName: String, completion: @escaping (Bool) -> Void) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.addFriend(userName, completion: completion)
    }
}
