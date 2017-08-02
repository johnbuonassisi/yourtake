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
    backendClient.getFriends(completion: completion)
  }
  
  func getNumberOfFriends(completion: @escaping (Int) -> Void) {
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.getFriends(completion: {(friends) -> Void in
      completion(friends.count)
    })
  }

}
