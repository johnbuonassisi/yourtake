//
//  FriendListViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-20.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class FriendListViewController: UITableViewController {
    
    private let userName : String
    private var areAllFriendsSelected : Bool = true
    private var friendSelectionTracker : FriendListData
    
    // MARK: Initializers
    init(withUser userName: String) {
        
        self.userName = userName
        let friends = UserDatabase.global.GetUser(userName)?.friends
        friendSelectionTracker = FriendListData(withFriends: friends!)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userName = ""
        friendSelectionTracker = FriendListData(withFriends: [""])
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib : UINib = UINib(nibName: "FriendCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "FriendCell")
        tableView?.backgroundColor = UIColor.white
        
        // Setup the navigation bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "Select Friends"

    }
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.isSelected = false
    }
    
    // MARK: UITableViewDataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friends = UserDatabase.global.GetUser(userName)?.friends
        return (friends?.count)! + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        if(indexPath.row == 0)
        {
            cell.friendName.text = "All Friends"
            cell.friendSwitch.setOn(friendSelectionTracker.areAllFriendsSelected, animated: true)
            cell.friendSwitch.addTarget(self,
                                        action: #selector(friendSwitchTapped),
                                        for: .valueChanged)
        } else {
            
            let friends = UserDatabase.global.GetUser(userName)?.friends
            cell.friendName.text = friends?[indexPath.row - 1]
            cell.friendSwitch.setOn(friendSelectionTracker.isFriendSelected(withName: cell.friendName.text!),
                                    animated: true)
            cell.friendSwitch.addTarget(self,
                                        action: #selector(friendSwitchTapped),
                                        for: .valueChanged)
        }
        return cell
    }
    
    
    // MARK: Action Methods
    
    @IBAction func doneButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allFriendsSwitchTapped(allFriendsSwitch: UISwitch) {
        

        
        tableView.reloadData()
    }
    
    @IBAction func friendSwitchTapped(friendSwitch: UISwitch) {
        
        let cell = friendSwitch.superview?.superview as! FriendCell
        
        if cell.friendName.text == "All Friends" {
            
            if friendSwitch.isOn == false {
                friendSelectionTracker.notAllFriendsSelected()
            } else {
                friendSelectionTracker.allFriendsSelected()
            }
        
        } else {
            
            if friendSwitch.isOn == false {
                friendSelectionTracker.friendUnselected(withName: cell.friendName.text!)
            } else {
                friendSelectionTracker.friendSelected(withName: cell.friendName.text!)
            }
        }
        
        tableView.reloadData()
    }
    

}
