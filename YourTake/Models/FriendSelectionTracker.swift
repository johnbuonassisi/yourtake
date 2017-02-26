//
//  FriendSelectionTracker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-02-26.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendSelectionTracker: NSObject {
    
    private var friendSelectionMap = [String: Bool]()
    var areAllFriendsSelected = true
    
    init(withFriends friends:[String]) {
        
        for friendName in friends {
            friendSelectionMap[friendName] = true
        }
    }
    
    // Change selection for a certain friend
    func changeSelection(forFriend friend: String) -> Bool? {
        
        if let isSelected = friendSelectionMap[friend] {
            friendSelectionMap.updateValue(!isSelected, forKey: friend)
            updateAllFriendsSelected()
            return !isSelected
        }
        
        return nil
        
    }
    
    // Change selection of all friends
    func changeSelectionOfAllFriends() -> Bool {
        
        if !areAllFriendsSelected {
            for (friend, _) in friendSelectionMap {
                friendSelectionMap[friend] = true
            }
            areAllFriendsSelected = true
        } else {
            areAllFriendsSelected = true
        }
        
        return areAllFriendsSelected
    }
    
    func isFriendSelected(forFriend friend: String) -> Bool? {
        return friendSelectionMap[friend]
    }
    
    func getAllSelectedFriends() -> [String] {
        
        var selectedFriends = [String]()
        for (friend, isFriendSelected) in friendSelectionMap {
            if isFriendSelected {
                selectedFriends.append(friend)
            }
        }
        return selectedFriends
    }
    
    
    // Update flag that indicates if all friends were selected
    private func updateAllFriendsSelected() {
        
        for (_, isSelected) in friendSelectionMap {
            if !isSelected {
                areAllFriendsSelected = false
                return
            }
        }
        areAllFriendsSelected = true
        return
    }
    
    

}
