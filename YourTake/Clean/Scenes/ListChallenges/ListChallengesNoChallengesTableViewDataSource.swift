//
//  ListChallengesNoChallengesTableViewDataSource.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-29.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class ListChallengesNoChallengesTableViewDataSource: NSObject, UITableViewDataSource {
  
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyChallengeTableViewCell", for: indexPath) as! EmptyChallengeTableViewCell
    return cell
  }


}
