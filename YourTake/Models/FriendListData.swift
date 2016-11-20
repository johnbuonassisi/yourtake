//
//  friendListData.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-20.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class FriendListData: NSObject {

    var friends : [(String, Bool)] = [(String, Bool)]()
    var areAllFriendsSelected : Bool = true
    
    init(withFriends friends:[String])
    {
        for index in 0...friends.count - 1 {
            self.friends.append((friends[index], true))
        }
        
        super.init()
    }
    
    func allFriendsSelected() {
        
        for index in 0...friends.count - 1 {
            friends[index].1 = true
        }
        areAllFriendsSelected = true
    }
    
    func notAllFriendsSelected() {
        for index in 0...friends.count - 1 {
            friends[index].1 = false
        }
        areAllFriendsSelected = false
    }
    
    func friendSelected(withName name: String) {
    
        for index in 0...friends.count - 1 {
            if friends[index].0 == name {
                friends[index].1 = true
            }
        }
        
        for friend in friends {
            if friend.1 == false {
                return
            }
        }
        
        areAllFriendsSelected = true
    }
    
    func friendUnselected(withName name: String) {
        
        for index in 0...friends.count - 1 {
            if friends[index].0 == name {
                friends[index].1 = false
            }
        }
        areAllFriendsSelected = false
    }
    
    func isFriendSelected(withName name:String) -> Bool {
        
        for index in 0...friends.count - 1 {
            if friends[index].0 == name {
                return friends[index].1
            }
        }
        return false
    }
}
