//
//  FriendListViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-20.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ChallengeOptionsViewController: UITableViewController,
                                      UINavigationControllerDelegate {
    
    private let userName : String
    private var areAllFriendsSelected : Bool = true
    private var friendSelectionTracker : FriendListData
    private var countdownDuration : Double
    private let challengeImage : UIImage
    
    // Uploading View
    let uploadActivityView = UIView()
    let uploadingLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    var alert: UIAlertController!
    
    // MARK: Initializers
    
    init(withUser userName: String, andImage image: UIImage) {
        
        self.userName = userName
        challengeImage = image
        let friends = UserDatabase.global.GetUser(userName)?.friends
        friendSelectionTracker = FriendListData(withFriends: friends!)
        countdownDuration = 600.0 // 10 minutes
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userName = ""
        friendSelectionTracker = FriendListData(withFriends: [""])
        countdownDuration = 0.0
        challengeImage = UIImage()
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Register the friend picker cell
        let fpNib = UINib(nibName: "FriendPickerCell", bundle: nil)
        tableView?.register(fpNib, forCellReuseIdentifier: "FriendPickerCell")
        
        // Register the expiry picker cell
        let epNib = UINib(nibName: "ExpiryPickerCell", bundle: nil)
        tableView?.register(epNib, forCellReuseIdentifier: "ExpiryPickerCell")
        
        tableView?.backgroundColor = UIColor.white
        
        // Setup the navigation bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "Create Challenge"

    }
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: // Date Picker Section
            return 200.0
        case 1: fallthrough // All Friends Picker Section
        case 2: // Friends Picker Section
            return 50.0
        default: // Should never get here
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath) as! FriendPickerCell
        cell.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: // Date Picker Section
            return "Choose Duration"
        case 1: // All Friends Picker Section
            return "Choose Friends"
        default:
            return nil
        }
    }
    
    // MARK: UITableViewDataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: // Date Picker Section
            return 1
        case 1: // All Friend Picker Section
            return 1
        case 2: // Friend Picker Section
            let friends = UserDatabase.global.GetUser(userName)?.friends
            return (friends?.count)!
        default: // Should never get here
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // Date Picker Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpiryPickerCell", for: indexPath) as! ExpiryPickerCell
            cell.expiryPicker.countDownDuration = countdownDuration
            cell.expiryPicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell
            
        case 1: // All Friend Picker Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath) as! FriendPickerCell
            cell.friendName.text = "All Friends"
            cell.friendSwitch.setOn(friendSelectionTracker.areAllFriendsSelected, animated: true)
            cell.friendSwitch.addTarget(self,
                                        action: #selector(friendSwitchTapped),
                                        for: .valueChanged)
            cell.friendSwitch.addTarget(self,
                                        action: #selector(friendSwitchTapped),
                                        for: .touchUpInside)
            return cell
        case 2: // Friend Picker Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath) as! FriendPickerCell
            let friends = UserDatabase.global.GetUser(userName)?.friends
            
            cell.friendName.text = friends?[indexPath.row]
            cell.friendSwitch.setOn(friendSelectionTracker.isFriendSelected(withName: cell.friendName.text!),
                                    animated: true)
            
            cell.friendSwitch.addTarget(self,
                                        action: #selector(friendSwitchTapped),
                                        for: .valueChanged)
            return cell
        default: // Should never get here
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath)
            return cell
        }
    }

    
    // MARK: Action Methods
    
    @IBAction func doneButtonTapped() {
        
        showUploadingAlert()
        let newChallenge = Challenge(owner: UserDatabase.global.John(),
                                     image: challengeImage,
                                     friends: friendSelectionTracker.getAllSelectedFriends(),
                                     expiryDate: NSDate(timeIntervalSinceNow: countdownDuration))
        UserDatabase.global.John().add(challenge: newChallenge)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.alert.dismiss(animated: true, completion: {
                _ = self.navigationController?.popToRootViewController(animated: false)
            })
        })
    }
    
    @IBAction func allFriendsSwitchTapped(allFriendsSwitch: UISwitch) {
        tableView.reloadData()
    }
    
    @IBAction func friendSwitchTapped(friendSwitch: UISwitch) {
        
        print("New switch")
        
        let cell = friendSwitch.superview?.superview as! FriendPickerCell
        
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
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        countdownDuration = datePicker.countDownDuration
    }
    
    // MARK: Private Methods
    
    private func setUploadingScreen() {
        
        let width: CGFloat = 120
        let height: CGFloat = 120
        let x = tableView.frame.width / 2 - width / 2
        let y = tableView.frame.height / 2 - height / 2 - 50
        uploadActivityView.frame = CGRect(x: x, y: y, width: width, height: height)
        uploadActivityView.isHidden = true
        uploadActivityView.backgroundColor = UIColor.black
        
        // set uploading text
        uploadingLabel.textColor = UIColor.gray
        uploadingLabel.textAlignment = .center
        uploadingLabel.text = "Uploading..."
        uploadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // set spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        uploadActivityView.addSubview(uploadingLabel)
        uploadActivityView.addSubview(spinner)
        
        // add spinner to view
        self.tableView.addSubview(uploadActivityView)
    }
    
    private func showUploadingAlert() {
        alert = UIAlertController(title: "Uploading",
                                      message: nil,
                                      preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.activityIndicatorViewStyle = .gray
        
        alert.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        present(alert, animated: true, completion: nil)
    }

}
