//
//  ListChallengesNoFriendsTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-10.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ListChallengesNoFriendsTableViewDataSource: NSObject, UITableViewDataSource {
  
  weak var viewController: ListChallengesViewController!
  
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: NO_FRIENDS_CELL_ID, for: indexPath) as! NoFriendsCell
    cell.addFriendsButton.addTarget(viewController,
                                            action: #selector(viewController.addFriends),
                                            for: .touchUpInside)
    return cell
  }
  
}
