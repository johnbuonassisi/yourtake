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
                               UIImagePickerControllerDelegate,
                               UITabBarDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarControl: UITabBar!
    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    
    // MARK: Private Member Variables
    
    private var user: User?
    private var userChallenges = [Challenge]()
    private var friendChallenges = [Challenge]()
    
    private var selectedRow : IndexPath?
    private var ip : UIImagePickerController?
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        // Load and register cell NIB
        let nib : UINib = UINib(nibName: "ChallengeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChallengeCellTest")
        
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
        tableView.refreshControl?.tintColor = UIColor.blue
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        // Setup the tab bar control
        tabBarControl.delegate = self
        tabBarControl.selectedItem = tabBarControl.items?[0]
        
        // get initial data from source
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getUser(completion: { (object) -> Void in self.user = object})
        backendClient.getChallenges(for: false, completion: { (objects) -> Void in self.userChallenges = objects})
        backendClient.getChallenges(for: true, completion: { (objects) -> Void in self.friendChallenges = objects})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reload a row that was previously selected
        if let selectedRow = selectedRow {
            tableView.reloadRows(at: [selectedRow], with: UITableViewRowAnimation.none)
        }
        selectedRow = nil
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.frame.width + 2 * 50) // 50 pts for header, 50 pts for footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            return userChallenges.count
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
        let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCellTest",
                                                                 for: indexPath) as! ChallengeCell
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            challenge = userChallenges[indexPath.row]
            
            cell.drawButton.addTarget(indexPath.row, action: #selector(cellDrawButtonPressed), for: .touchUpInside)
            cell.voteButton.addTarget(indexPath.row, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
        case 1:
            challenge = friendChallenges[indexPath.row]
            
            cell.drawButton.addTarget(indexPath.row, action: #selector(cellDrawButtonPressed), for: UIControlEvents.touchUpInside)
            cell.voteButton.addTarget(indexPath.row, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
        default:
            return cell
        }
        
        if challenge != nil {
            cell.id = challenge!.id
            cell.challengeImage.image = challenge!.image
            cell.name.text = challenge!.author
            cell.expiryLabel.text = getExpiryLabel(fromDate: challenge!.duration as Date)
            cell.totalVotesLabel.text = String(challenge!.getTotalVotes()) + " total votes"
            
            if challenge!.author == user?.username {
                cell.drawButton.isEnabled = false
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
        backendClient.getUser(completion: { (object) -> Void in self.user = object})
        backendClient.getChallenges(for: false, completion: { (objects) -> Void in self.userChallenges = objects})
        backendClient.getChallenges(for: true, completion: { (objects) -> Void in self.friendChallenges = objects})
        
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    func cellDrawButtonPressed(index : Int) {
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            challenge = userChallenges[index]
        case 1:
            challenge = friendChallenges[index]
        default: break
        }
        
        let dvc: DrawViewController = DrawViewController(nibName: "DrawViewController",
                                                         bundle: Bundle.main,
                                                         withChallenge: challenge!)
        
        selectedRow = IndexPath(row: index, section: 0)
        navigationController?.pushViewController(dvc, animated: true)
        dvc.loadViewIfNeeded()
        dvc.drawingView.setBackground(withImage: challenge?.image)
    }
    
    func cellVoteButtonPressed(index: Int) {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        var challenge: Challenge?
        switch(tabBarControl.selectedItem!.tag) {
        case 0:
            challenge = userChallenges[index]
        case 1:
            challenge = friendChallenges[index]
        default: break
        }
        
        selectedRow = IndexPath(row: index, section: 0)
        let tcvc = TakesCollectionViewController(collectionViewLayout: layout, withChallenge: challenge!)
        navigationController?.pushViewController(tcvc, animated: true)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        tableView.reloadData()
    }
    
    // MARK: Private Methods
    
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
    
}
