//
//  ListChallengesNoFriendsTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-05-10.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

@objc protocol ListChallengesNoFriendsTableViewDataSourceDelegate: class {
    func viewFriendsManagement(_ sender: Any)
}

class ListChallengesNoFriendsTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: ListChallengesNoFriendsTableViewDataSourceDelegate!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListChallengeSceneCellIdentifiers.noFriendsCellId,
                                                 for: indexPath) as! NoFriendsCell
        cell.addFriendsButton.addTarget(delegate,
                                        action: #selector(delegate.viewFriendsManagement),
                                        for: .touchUpInside)
        return cell
    }
}
