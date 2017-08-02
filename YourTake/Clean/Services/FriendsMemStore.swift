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
  
  func getFriends(completion: @escaping ([String]) -> Void) {
    completion(friendList)
  }
  
  func getNumberOfFriends(completion: @escaping (Int) -> Void) {
    completion(friendList.count)
  }

}
