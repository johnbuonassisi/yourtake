//
//  FriendsMemStore.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendsMemStore: FriendsStoreProtocol {
    
    var friendList = ["Ashling", "Anthony", "Daniella"]
    var userList = ["Ashling", "Anthony", "Daniella", "Olivier", "John", "Bob", "Ted", "Judy",
                    "Zack", "Stewart", "Bill", "Riley", "Patrick", "Jason", "Will", "Michael", "Andrea",
                    "Lucia", "Sid", "Samuel", "Andre", "Blaine", "Jim", "Sam"]
    var followerList = ["Ashling", "Anthony", "Daniella", "Olivier", "John"]
    var followingList = ["Ashling", "Anthony", "Daniella", "Bob", "Ted", "Judy"]
    
    func getFriends(completion: @escaping ([String]) -> Void) {
        completion(friendList)
    }
    
    func getNumberOfFriends(completion: @escaping (Int) -> Void) {
        completion(friendList.count)
    }
    
    func getFollowers(completion: @escaping ([String]?) -> Void) {
        completion(followerList)
    }
    
    func getFollowing(completion: @escaping ([String]?) -> Void) {
        completion(followingList)
    }
    
    func getUsers(completion: @escaping ([String]?) -> Void) {
        completion(userList)
    }
    
    func followUser(userName: String, completion: @escaping (Bool) -> Void) {
        followingList.append(userName)
        completion(true)
    }
    
}
