//
//  ChallengeViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-31.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController,
                               UITableViewDelegate,
                               UITableViewDataSource,
                               UINavigationControllerDelegate,
                               UIImagePickerControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    
    @IBOutlet weak var tabBarControl: UITabBar!
    @IBOutlet weak var userChallengeTabBarItem: UITabBarItem!
    @IBOutlet weak var friendChallengeTabBarItem: UITabBarItem!
    
    // MARK: Private Member Variables
    
    private var selectedRow : IndexPath?
    private var ip : UIImagePickerController?
    private let systemBlueColor = UIColor(red: 0.0,
                                          green: 122.0/255.0,
                                          blue: 255.0/255.0,
                                          alpha: 1.0)
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        // Load and register cell NIB
        let nib : UINib = UINib(nibName: "ChallengeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChallengeCell")
        
        // Set the cell height
        tableView.rowHeight = ChallengeCell.CellRowHeight()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        // Setup the navigation bar
        navigationItem.title = "YourTake"
        
        let rbbi = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera,
                                   target: self,
                                   action: #selector(ChallengeViewController.newChallenge))
        
        let lbbi = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize,
                                   target: self,
                                   action: nil)
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.leftBarButtonItem = lbbi
        
        navigationController?.navigationBar.isHidden = false
        
        // Setup the refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = systemBlueColor
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        // Setup the tab bar control
        tabBarControl.delegate = self
        tabBarControl.selectedItem = tabBarControl.items?[0]
        userChallengeTabBarItem.badgeColor = systemBlueColor
        friendChallengeTabBarItem.badgeColor = systemBlueColor
        updateTabBarBadges()
        
        // Allow buttons contained within tableviewcells to be animated when pressed
        // See Stack Overflow Question: "UIButton not showing highlight on tap in iOS7"
        for view in tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Reload a row that was previously selected
        if let selectedRow = selectedRow {
            tableView.reloadRows(at: [selectedRow], with: UITableViewRowAnimation.none)
        }
        selectedRow = nil
        
        updateTabBarBadges()
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.frame.width + 2*50) // 50 pts for header, 50 pts for footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let john = UserDatabase.global.John()
        switch(tabBarControl.selectedItem!.tag){
        
        case 0: // User Challenges
            // Client
            return john.getNumChallenges()
            
        case 1: // Friend Challenges
            // Client
            return UserDatabase.global.GetNumberOfFriendChallenges(forUserWithName: john.name)
        default: // ??
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell",
                                                                 for: indexPath) as! ChallengeCell
        let john = UserDatabase.global.John()
        var challenge: Challenge?
        
        switch(tabBarControl.selectedItem!.tag){
        
        case 0: // User Challenges
            challenge = john.getChallenge(indexPath.row)
            
        case 1: // Friend Challenges
            challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: john.name, atIndex: indexPath.row)
            
        default: // ??
            return cell
        }
        
        customizeCell(&cell, withChallenge: challenge!, atRowNumber: indexPath.row)
        return cell
        
    }
    
    
    // MARK: Action Methods
    
    @IBAction func newChallenge() {
        
        let ppvc = PhotoPreviewViewController(nibName: "PhotoPreviewView", bundle: nil)
        navigationController?.pushViewController(ppvc, animated: false)
        
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        ip!.takePicture()
    }
    
    @IBAction func cancelTakingPhoto(_ sender: UIBarButtonItem) {
        ip?.dismiss(animated: true, completion: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func changeCamera(_ sender: UIBarButtonItem) {
        if sender.title! == "Rear" {
            ip?.cameraDevice = .rear
            sender.title! = "Front"
        } else {
            ip?.cameraDevice = .front
            sender.title! = "Rear"
        }
    }
    
    @IBAction func segmentChanges(_ sender: UISegmentedControl) {
        
        tableView.reloadData()
    }
    
    func refresh() {
        
        tableView.reloadData()
        updateTabBarBadges()
        tableView.refreshControl?.endRefreshing()
    }
    
    func cellDrawButtonPressed(button : UIButton){
        
        let challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        
        case 0: // User Challenges
            challenge = UserDatabase.global.John().getChallenge(button.tag)
        case 1: // Friend Challenges
            challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: UserDatabase.global.John().name,
                                                               atIndex: button.tag)
        default:
            challenge = nil
        }
        
        let dvc: DrawViewController = DrawViewController(nibName: "DrawViewController",
                                                         bundle: Bundle.main,
                                                         withChallenge: challenge!)
        
        selectedRow = IndexPath(row: button.tag, section: 0)
        navigationController?.pushViewController(dvc, animated: true)
        dvc.loadViewIfNeeded()
        dvc.drawingView.setBackground(withImage: challenge?.image)
    }
    
    func cellVoteButtonPressed(button: UIButton) {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let challenge : Challenge?
        switch(tabBarControl.selectedItem!.tag)
        {
        case 0: // User Challenges
            challenge = UserDatabase.global.John().getChallenge(button.tag)
        case 1: // Friend Challenges
            challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: UserDatabase.global.John().name,
                                                               atIndex: button.tag)
        default:
            challenge = nil
        }
        
        selectedRow = IndexPath(row: button.tag, section: 0)
        let tcvc = TakesCollectionViewController(collectionViewLayout: layout, withChallenge: challenge!)
        navigationController?.pushViewController(tcvc, animated: true)
    }
    
    // MARK: Private Helper Methods
    
    private func getExpiryLabel(fromDate date: Date) -> String {
        
        let numSecondsRemaining : Int = Int(date.timeIntervalSince(Date()))
        
        if( numSecondsRemaining <= 0){
            return String("Challenge completed")
        }
        
        let numDaysRemaining = numSecondsRemaining / ( 60 * 60 * 24)
        if(numDaysRemaining > 0) {
            if numDaysRemaining == 1 {
                return String(numDaysRemaining) + " day remaining"
            }
            return String(numDaysRemaining) + " days remaining"
        }
        
        let numHoursRemaining = numSecondsRemaining / ( 60 * 60 )
        if( numHoursRemaining > 0) {
            if numHoursRemaining == 1 {
                return String(numHoursRemaining) + "hour remaining"
            }
            return String(numHoursRemaining) + " hours remaining"
        }
        
        let numMinutesRemaining = numSecondsRemaining / 60
        if(numMinutesRemaining > 0){
            if numHoursRemaining == 1 {
                return String(numMinutesRemaining) + "minute remaining"
            }
            return String(numMinutesRemaining) + " minutes remaining"
        }
        if numSecondsRemaining == 1 {
            return String(numSecondsRemaining) + "second remaining"
        }
        
        return String(numSecondsRemaining) + " seconds remaining"
    }
    
    private func updateTabBarBadges() {
        
        let numActiveUserChallenges = UserDatabase.global.John().getNumChallenges() -
            UserDatabase.global.John().getNumExpiredChallenges()
        if numActiveUserChallenges == 0 {
            userChallengeTabBarItem.badgeValue = nil
        } else {
            userChallengeTabBarItem.badgeValue = String(numActiveUserChallenges)
        }
        
        let numActiveFriendChallenges = UserDatabase.global.GetNumberOfActiveFriendChallenges(forUserWithName: UserDatabase.global.John().name)
        if numActiveFriendChallenges == 0 {
            friendChallengeTabBarItem.badgeValue = nil
        } else {
            friendChallengeTabBarItem.badgeValue = String(numActiveFriendChallenges)
        }
    }
    
    private func customizeCell(_ cell: inout ChallengeCell, withChallenge challenge: Challenge, atRowNumber row: Int) {
        
        cell.drawButton.addTarget(self, action: #selector(cellDrawButtonPressed), for: .touchUpInside)
        cell.voteButton.addTarget(self, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
        
        cell.challengeImage.image = challenge.image
        cell.name.text = challenge.owner!.name
        cell.expiryLabel.text = getExpiryLabel(fromDate: challenge.expiryDate as Date)
        cell.totalVotesLabel.text = String(challenge.getTotalVotes()) + " total votes"
        
        if challenge.isExpired() {
            cell.drawButton.isEnabled = false
            cell.voteButton.setTitle("View", for: .normal)
        } else {
            cell.drawButton.isEnabled = true
            cell.voteButton.setTitle("Vote", for: .normal)
        }
        
        // Client
        if challenge.wasTakeSubmittedByUser(withName: "John") {
            cell.drawButton.isEnabled = false
        }
        
        cell.drawButton.tag = row
        cell.voteButton.tag = row

    }
    
}

extension ChallengeViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        tableView.reloadData()
    }
}
