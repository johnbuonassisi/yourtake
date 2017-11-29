//
//  FriendWorker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendsWorker {
    
    private var friendsStore: FriendsStoreProtocol
    
    init(friendsStore: FriendsStoreProtocol) {
        self.friendsStore = friendsStore
    }
    
    func getFriends(completion: @escaping ([String]) -> Void) {
        friendsStore.getFriends(completion: completion)
    }
    
    func getNumberOfFriends(completion: @escaping (Int) -> Void) {
        friendsStore.getNumberOfFriends(completion: completion)
    }
    
    func getFollowers(completion: @escaping ([String]) -> Void) {
        friendsStore.getFollowers(completion: completion)
    }
    
    func getFollowing(completion: @escaping ([String]) -> Void) {
        friendsStore.getFollowing(completion: completion)
    }
    
    func getUsers(completion: @escaping ([String]) -> Void) {
        friendsStore.getUsers(completion: completion)
    }
    
    func followUser(userName: String, completion: @escaping (Bool) -> Void) {
        friendsStore.followUser(userName: userName, completion: completion)
    }
}

protocol FriendsStoreProtocol {
    
    func getFriends(completion: @escaping ([String]) -> Void)
    func getNumberOfFriends(completion: @escaping (Int) -> Void)
    func getFollowers(completion: @escaping ([String]) -> Void)
    func getFollowing(completion: @escaping ([String]) -> Void)
    func getUsers(completion: @escaping ([String]) -> Void)
    func followUser(userName: String, completion: @escaping (Bool) -> Void)
}
