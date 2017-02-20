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
    
    private var user: User?
    private var userChallenges = [Challenge]()
    private var friendChallenges = [Challenge]()
    
    private var selectedRow : IndexPath?
    private var ip : UIImagePickerController?
    private let systemBlueColor = UIColor(red: 0.0,
                                          green: 122.0/255.0,
                                          blue: 255.0/255.0,
                                          alpha: 1.0)
    private var isChallengeTableEmpty = false;
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        // Load and register cell NIBs
        let nib1: UINib = UINib(nibName: "ChallengeCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "ChallengeCell")
        
        let nib2: UINib = UINib(nibName: "EmptyChallengeCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "EmptyChallengeCell")
        
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
                                   action: #selector(self.settingsButtonTapped))
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
        
        // get initial data from source
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getUser(completion: { (object) -> Void in self.user = object})

        backendClient.getChallenges(for: false, completion: { (objects) -> Void in
            self.tableView.refreshControl!.endRefreshing()
            self.tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.userChallenges = objects
            self.isChallengeTableEmpty = self.userChallenges.isEmpty
            self.tableView.reloadData();
            self.updateTabBarBadges();
        })
        backendClient.getChallenges(for: true, completion: { (objects) -> Void in
            self.tableView.refreshControl!.endRefreshing()
            self.tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.friendChallenges = objects
            self.tableView.reloadData();
            self.updateTabBarBadges();
        })
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
        return CGFloat(tableView.frame.width + 2 * 50) // 50 pts for header, 50 pts for footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            if userChallenges.isEmpty {
                isChallengeTableEmpty = true
                return 1;
            } else {
                return userChallenges.count
            }
        case 1:
            return friendChallenges.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            if isChallengeTableEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyChallengeCell", for: indexPath) as! EmptyChallengeCell
                emptyCell.createNewChallengeButton.addTarget(self, action: #selector(newChallenge), for: .touchUpInside)
                return emptyCell
            }
            challenge = userChallenges[indexPath.row]
            
        case 1:
            challenge = friendChallenges[indexPath.row]
            
        default:
            break
        }
        
        let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell",
                                                                 for: indexPath) as! ChallengeCell
        cell.drawButton.tag = indexPath.row
        cell.drawButton.addTarget(self, action: #selector(cellDrawButtonPressed), for: .touchUpInside)
        
        cell.drawButton.tag = indexPath.row
        cell.voteButton.addTarget(self, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
        
        if challenge != nil {
            cell.id = challenge!.id
            cell.challengeImage.image = challenge!.image
            cell.name.text = challenge!.author
            cell.expiryLabel.text = getExpiryLabel(fromDate: challenge!.getTimeRemaining() as Date)
            cell.totalVotesLabel.text = String(challenge!.getTotalVotes()) + " total votes"
            
            if challenge!.author == user?.username {
                cell.drawButton.isEnabled = true
            } else {
                cell.drawButton.isEnabled = true
            }
        }
        
        return cell
    }
    
    
    // MARK: Action Methods
    
    @IBAction func newChallenge() {
        
        let ppvc = PhotoPreviewViewController(nibName: "PhotoPreviewView", bundle: nil)
        navigationController?.pushViewController(ppvc, animated: false)
        
    }
    
    @IBAction func settingsButtonTapped() {
        
        let settingsStoryboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
        let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: "Settings")
        navigationController?.pushViewController(settingsViewController, animated: true)
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
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getUser(completion: { (object) -> Void in self.user = object; self.tableView.reloadData() })
        
        backendClient.getChallenges(for: false, completion: { (objects) -> Void in
            self.userChallenges = objects
            self.isChallengeTableEmpty = self.userChallenges.isEmpty
            self.tableView.reloadData()
            self.updateTabBarBadges()
        })
        backendClient.getChallenges(for: true, completion: { (objects) -> Void in
            self.friendChallenges = objects
            self.tableView.reloadData()
            self.updateTabBarBadges()
        })
        
        tableView.refreshControl?.endRefreshing()
    }
    
    func cellDrawButtonPressed(button: UIButton) {
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            challenge = userChallenges[button.tag]
        case 1:
            challenge = friendChallenges[button.tag]
        default: break
        }
        
        let dvc: DrawViewController = DrawViewController(nibName: "DrawViewController",
                                                         bundle: Bundle.main,
                                                         withChallenge: challenge!)
        
        navigationController?.pushViewController(dvc, animated: true)
        dvc.loadViewIfNeeded()
        dvc.drawingView.setBackground(withImage: challenge?.image)
    }
    
    func cellVoteButtonPressed(button: UIButton) {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            challenge = userChallenges[button.tag]
        case 1:
            challenge = friendChallenges[button.tag]
        default: break
        }
        
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
        var activeUserChallenges = 0
        for challenge in userChallenges {
            if challenge.isExpired() {
                activeUserChallenges += 1
            }
        }
        
        if activeUserChallenges == 0 {
            userChallengeTabBarItem.badgeValue = nil
        } else {
            userChallengeTabBarItem.badgeValue = String(activeUserChallenges)
        }
        
        var activeFriendChallenges = 0
        for challenge in friendChallenges {
            if challenge.isExpired() {
                activeFriendChallenges += 1
            }
        }
        
        if activeFriendChallenges == 0 {
            friendChallengeTabBarItem.badgeValue = nil
        } else {
            friendChallengeTabBarItem.badgeValue = String(activeFriendChallenges)
        }
    }
    
    private func customizeCell(_ cell: inout ChallengeCell, withChallenge challenge: Challenge, atRowNumber row: Int) {
        cell.drawButton.addTarget(row, action: #selector(cellDrawButtonPressed), for: .touchUpInside)
        cell.voteButton.addTarget(row, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
        
        cell.challengeImage.image = challenge.image
        cell.name.text = challenge.author
        cell.expiryLabel.text = getExpiryLabel(fromDate: challenge.getTimeRemaining())
        cell.totalVotesLabel.text = String(challenge.getTotalVotes()) + " total votes"
        
        if challenge.isExpired() {
            cell.drawButton.isEnabled = false
            cell.voteButton.setTitle("View", for: .normal)
        } else {
            cell.drawButton.isEnabled = true
            cell.voteButton.setTitle("Vote", for: .normal)
        }
        
        // Client
        if challenge.author == user?.username {
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
