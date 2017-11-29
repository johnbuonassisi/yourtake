//
//  FriendManagementTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-28.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import Foundation

class FriendManagementTableViewDataSource: NSObject, UITableViewDataSource {
    
    var section1Model: [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]
    var section2Model: [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]
    var section1HeaderTitle: String
    var section2HeaderTitle: String
    
    weak var viewController: FriendManagementViewController!
    
    override init() {
        section1Model = [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]()
        section2Model = [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]()
        section1HeaderTitle = String()
        section2HeaderTitle = String()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1Model.count
        } else {
            return section2Model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(
                withIdentifier: FriendManagementCellIdentifiers.friendManagementCellId,
                for: indexPath) as! FriendManagementTableViewCell
        var user: FriendManagementScene.FetchFriends.ViewModel.UserViewModel
        
        if indexPath.section == 0 {
            user = section1Model[indexPath.row]
            tableViewCell.actionButton.removeTarget(self,
                                                    action: #selector(self.friendCellSection2ActionButtonPressed),
                                                    for: .touchUpInside)
            tableViewCell.actionButton.addTarget(self,
                                                 action: #selector(self.friendCellSection1ActionButtonPressed),
                                                 for: .touchUpInside)
        } else {
            user = section2Model[indexPath.row]
            tableViewCell.actionButton.removeTarget(self,
                                                    action: #selector(self.friendCellSection1ActionButtonPressed),
                                                    for: .touchUpInside)
            tableViewCell.actionButton.addTarget(self,
                                                 action: #selector(self.friendCellSection2ActionButtonPressed),
                                                 for: .touchUpInside)
        }
        
        tableViewCell.userNameLabel.text = user.userName
        tableViewCell.actionButton.setTitle(user.buttonTitle, for: .normal)
        tableViewCell.actionButton.isEnabled = user.isButtonEnabled
        tableViewCell.actionButton.backgroundColor = user.buttonColour
        tableViewCell.actionButton.tag = indexPath.row

        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return section1HeaderTitle
        } else {
            return section2HeaderTitle
        }
    }
    
    func friendCellSection1ActionButtonPressed(sender: UIButton!) {
        print("Friend Cell Action Button Pressed in Section 1 Row \(sender.tag)")
        let user = section1Model[sender.tag]
        takeAction(for: user)

    }
    
    func friendCellSection2ActionButtonPressed(sender: UIButton!) {
        print("Friend Cell Action Button Pressed in Section 2 Row \(sender.tag)")
        let user = section2Model[sender.tag]
        takeAction(for: user)
    }
    
    private func takeAction(for user: FriendManagementScene.FetchFriends.ViewModel.UserViewModel) {
        if user.friendRequestType == .accept {
            viewController.acceptFriend(userName: user.userName)
        } else if user.friendRequestType == .request {
            viewController.requestFriend(userName: user.userName)
        }
    }
}
