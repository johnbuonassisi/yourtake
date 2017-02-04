//
//  FindFriendByEmailViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-01-28.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

class FindFriendByEmailViewController: UIViewController,
                                       UITableViewDelegate,
                                       UITableViewDataSource{

    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var friendEmailAddressTextField: UITextField!
    
    private var friendName: String? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        friendListTableView.dataSource = self
        friendListTableView.delegate = self
        friendEmailAddressTextField.delegate = self
        
        let nib = UINib(nibName: "FriendSelectionCell", bundle: nil);
        friendListTableView.register(nib, forCellReuseIdentifier: "FriendSelectionCell")
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if let friendEmail = friendEmailAddressTextField.text {
            // Search for friend in database
            let backendClient = Backend.sharedInstance.getClient()
            var userFriends = [String]()
            backendClient.getFriends(completion: { (friends) -> Void in
                userFriends = friends;
                
                for name in userFriends {
                    if name == friendEmail {
                        self.friendName = name
                    }
                }
                self.friendListTableView.reloadData()
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendSelectionCell =
            friendListTableView.dequeueReusableCell(withIdentifier: "FriendSelectionCell",
                                                    for: indexPath) as! FriendSelectionCell
        if friendEmailAddressTextField.text != "" {
            cell.friendNameLabel.text = friendName
            cell.addFriendButton.isHidden = false
            cell.addFriendButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        } else {
            cell.friendNameLabel.text = ""
            cell.addFriendButton.isHidden = true
        }
        return cell;
    }
    
    func addFriend() {
        // send friend request
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.addFriend(friendName!, completion: { (success) -> Void in
            if success {
                print("Added friend successfully")
            } else {
                print("Unable to add friend")
            }
        })
    }

}

extension FindFriendByEmailViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        friendListTableView.reloadData()
        return false
    }
}
