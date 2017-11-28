//
//  FriendManagementTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-28.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import Foundation

class FriendManagementTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: FriendManagementScene.FetchFriends.ViewModel
    weak var viewController: FriendManagementViewController!
    
    override init() {
        viewModel = FriendManagementScene.FetchFriends.ViewModel(friendsAndAcquaintances: [], otherUsers: [])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.friendsAndAcquaintances.count
        } else {
            return viewModel.otherUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
