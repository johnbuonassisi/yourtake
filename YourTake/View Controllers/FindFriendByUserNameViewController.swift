//
//  FindFriendByUserNameViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-02-18.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class FindFriendByUserNameViewController: UIViewController {

    @IBOutlet weak var friendUserNameTextField: UITextField!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        if let friendUserName = friendUserNameTextField.text {
            
            // subscribe to user
            let backendClient = Backend.sharedInstance.getClient()
            backendClient.getFriends(completion: { (friends) -> Void in
                
                for friend in friends {
                    if friend == friendUserName {
                        self.messageLabel.text = "You are already following " + friendUserName + "."
                        return
                    }
                }
                
                backendClient.addFriend(friendUserName, completion: { (success) -> Void in
                    if success {
                        self.messageLabel.text = "Yay, successfully subscribed to " + friendUserName + "!"
                    } else {
                        self.messageLabel.text = "Sorry, " + friendUserName + " is not a user."
                    }
                })
            })
            

        }
    }
    
    
    
    
}
