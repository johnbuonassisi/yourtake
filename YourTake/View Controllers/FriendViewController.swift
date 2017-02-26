//
//  FriendViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-02-25.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController,
                            UITableViewDataSource,
                            UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var friendList: [String]?;
    let cellReuseIdentifier = "FriendNameCell"
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        loadDataFromBackend()
        
    }
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friendList = friendList {
            return friendList.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = friendList?[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewDelegateMethods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends"
    }
    
    // MARK: Action Methods
    
    @IBAction func addFriendsButtonTapped(_ sender: Any) {
        
        if let friendUserName = userNameTextField.text {
            // subscribe to user
            let backendClient = Backend.sharedInstance.getClient()
            backendClient.getFriends(completion: { (friends) -> Void in
                for friend in friends {
                    if friend == friendUserName {
                        self.messageLabel.text = "Already following " + friendUserName + "."
                        return
                    }
                }
                backendClient.addFriend(friendUserName, completion: { (success) -> Void in
                    if success {
                        self.messageLabel.text = "Subscribed to " + friendUserName + "!"
                        self.loadDataFromBackend()
                        return
                    }
                    
                    if friendUserName.isEmpty {
                        self.messageLabel.text = "Oops, enter a user name"
                        return
                    }
                    
                    self.messageLabel.text = "Sorry, " + friendUserName + " is not a user."
                    
                })
            })
        }
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: Helpers
    
    private func configureTableView(){
    
        // Set the delegate and datasource to be this view controller
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register FriendNameCell for use in this table
        self.tableView.register(FriendNameCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
        // Disable user interaction, this table will just display a list of friend user names
        self.tableView.isUserInteractionEnabled = false
    }
    
    private func loadDataFromBackend() {
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFriends(completion: { friends -> Void in
            self.friendList = friends
            self.tableView.reloadData()
        })
    }
    
    

}
