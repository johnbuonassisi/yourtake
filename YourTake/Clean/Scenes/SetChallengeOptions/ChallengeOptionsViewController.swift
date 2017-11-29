//
//  FriendListViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-20.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ChallengeOptionsViewController: UIViewController,
                                      UITableViewDelegate,
                                      UITableViewDataSource,
                                      UINavigationControllerDelegate {
    
    @IBOutlet weak var expiryPicker: UIDatePicker!
    @IBOutlet weak var friendSelectionTableView: UITableView!
    
    private var friends: [String]?
    private var challengeImage : UIImage?
    private var friendSelectionTracker: FriendSelectionTracker?
    
    // Uploading View
    let uploadActivityView = UIView()
    let uploadingLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    var alert: UIAlertController!
    
    // MARK: Initializers
    
    init(withImage image: UIImage) {
        challengeImage = image
        super.init(nibName: "ChallengeOptionsViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expiryPicker.countDownDuration = 600
        friendSelectionTableView.delegate = self
        friendSelectionTableView.dataSource = self
        
        // Register the friend picker cell
        let fpNib = UINib(nibName: "FriendPickerCell", bundle: nil)
        friendSelectionTableView!.register(fpNib, forCellReuseIdentifier: "FriendPickerCell")
        
        // Setup the navigation bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "Create Challenge"
        
        // get initial data from source
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getFollowers { (followers) in
            backendClient.getFollowing(completion: { (following) in
                let followersSet = Set(followers)
                let followingSet = Set(following)
                let friendSet = followersSet.intersection(followingSet)
                self.friends = friendSet.sorted()
                self.friendSelectionTracker = FriendSelectionTracker(withFriends: self.friends!)
                self.friendSelectionTableView.reloadData()
            })
        }

    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: fallthrough // All Friends Picker Section
        case 1: // Friends Picker Section
            return 50.0
        default: // Should never get here
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("Selection: All Friends")
            if let friendSelectionTracker = friendSelectionTracker {
                _ = friendSelectionTracker.changeSelectionOfAllFriends()
                tableView.reloadData()
            }

        case 1:
            print("Selection: " + "\(friends![indexPath.row])")
            if let friendSelectionTracker = friendSelectionTracker {
                _ = friendSelectionTracker.changeSelection(forFriend: friends![indexPath.row])
                tableView.reloadData()
            }
            return
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // Date Picker Section
            return "Choose Friends"
        default:
            return nil
        }
    }
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Date Picker Section
            return 1
        case 1: // Friend Picker Section
            if friends != nil {
                return friends!.count
            } else {
                return 0
            }
        default: // Should never get here
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: // All Friend Picker Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath) as! FriendPickerCell
            cell.friendName.text = "All Friends"
            if let friendSelectionTracker = friendSelectionTracker {
                //print("All Friends Cell: " + "\(cell.friendSwitch.isOn)")
                cell.friendSwitch.setOn(friendSelectionTracker.areAllFriendsSelected, animated: true)
                //print("All Friends: \(friendSelectionTracker.areAllFriendsSelected)")
            }
            return cell
        case 1: // Friend Picker Section
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath) as! FriendPickerCell
            
            if let friends = friends {
                
                let friendName = friends[indexPath.row]
                cell.friendName.text = friendName
                
                if let friendSelectionTracker = friendSelectionTracker {
                    if let isSelected = friendSelectionTracker.isFriendSelected(forFriend: friendName) {
                        //print(friendName + " Cell: \(cell.friendSwitch.isOn)")
                        cell.friendSwitch.setOn(isSelected, animated: true)
                        //print(friendName + ": \(isSelected)")
                    }
                }
            }
            return cell
        default: // Should never get here
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPickerCell", for: indexPath)
            return cell
        }
    }
    
    
    // MARK: Action Methods
    
    @IBAction func doneButtonTapped() {
        
        if let friendSelectionTracker = friendSelectionTracker {
            
            let newChallenge = ChallengeDto(id: "",
                                            author: "",
                                            imageId: "",
                                            recipients: friendSelectionTracker.getAllSelectedFriends(),
                                            duration: expiryPicker.countDownDuration,
                                            created: Date())
            newChallenge.image = challengeImage!
            
            let backendClient = Backend.sharedInstance.getClient()
            backendClient.createChallenge(newChallenge, completion: { (success) -> Void in
                if success {
                    print("Challenge created successfully!")
                } else {
                    print("Failed to create challenge!")
                }
            })
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: Private Methods
    
    /*
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
     */

}
