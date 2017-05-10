//
//  FriendWorker.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendsWorker {
  
  var friendsStore: FriendsStoreProtocol
  
  init(friendsStore: FriendsStoreProtocol) {
    self.friendsStore = friendsStore
  }
  
  func getFriends(completion: @escaping ([String]) -> Void) {
    friendsStore.getFriends(completion: completion)
  }
  
  func getNumberOfFriends(completion: @escaping (Int) -> Void) {
    friendsStore.getNumberOfFriends(completion: completion)
  }
}

protocol FriendsStoreProtocol {
  
  func getFriends(completion: @escaping ([String]) -> Void)
  func getNumberOfFriends(completion: @escaping (Int) -> Void)
  
}
