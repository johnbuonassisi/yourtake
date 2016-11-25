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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var overlayView: UIView!
    
    // MARK: Private Member Variables
    
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
        
        let lbbi = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks,
                                   target: self,
                                   action: nil)
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.leftBarButtonItem = lbbi
        
        // Setup the refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.blue
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
    
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
        return CGFloat(tableView.frame.width + 2*50) // 50 pts for header, 50 pts for footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let john = UserDatabase.global.John()
        switch(segmentedControl.selectedSegmentIndex){
        
        case 0: // User Challenges
            // Client
            return john.challenges!.count
            
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
        let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCellTest",
                                                                 for: indexPath) as! ChallengeCell
        switch(segmentedControl.selectedSegmentIndex){
        
        case 0: // User Challenges
            
            cell.drawButton.addTarget(self, action: #selector(cellDrawButtonPressed), for: .touchUpInside)
            cell.voteButton.addTarget(self, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
            
            // Client
            let john = UserDatabase.global.John()
            let johnsChallenges = john.challenges![indexPath.row]
            
            cell.challengeImage.image = johnsChallenges.image
            cell.name.text = john.name
            cell.expiryLabel.text = getExpiryLabel(fromDate: johnsChallenges.expiryDate as Date)
            cell.totalVotesLabel.text = String(johnsChallenges.getTotalVotes()) + " total votes"
            cell.drawButton.isEnabled = true
            cell.drawButton.tag = indexPath.row
            cell.voteButton.tag = indexPath.row
            
            return cell
            
        case 1: // Friend Challenges
            
            cell.drawButton.addTarget(self, action: #selector(cellDrawButtonPressed), for: UIControlEvents.touchUpInside)
            cell.voteButton.addTarget(self, action: #selector(cellVoteButtonPressed), for: .touchUpInside)
                    
            // Client
            let john = UserDatabase.global.John()
            let challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: john.name, atIndex: indexPath.row)
            
            cell.challengeImage.image = challenge!.image
            cell.name.text = challenge!.owner!.name
            cell.expiryLabel.text = getExpiryLabel(fromDate: challenge!.expiryDate as Date)
            cell.totalVotesLabel.text = String(challenge!.getTotalVotes()) + " total votes"
            cell.drawButton.isEnabled = true
            cell.drawButton.tag = indexPath.row
            cell.voteButton.tag = indexPath.row
            
            return cell
            
        default: // ??
            return cell
        }
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // ?
        picker.dismiss(animated: true, completion: {
            let friendChallengeList = ChallengeOptionsViewController(withUser: "John")
            self.navigationController?.pushViewController(friendChallengeList, animated: true)
        })
    }
    
    // MARK: Action Methods
    
    @IBAction func newChallenge() {
        
        ip = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            ip!.sourceType = UIImagePickerControllerSourceType.camera
            ip!.showsCameraControls = false
            
            // Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView
            // outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view,
            // and set self's reference to the view to nil.
            Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)
            overlayView.frame = ip!.cameraOverlayView!.frame
            ip!.cameraOverlayView = self.overlayView
            self.overlayView = nil // break a strong reference cycle
            
        } else {
            
            ip!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        let friendChallengeList = ChallengeOptionsViewController(withUser: "John")
        ip!.delegate = friendChallengeList
        self.present(ip!, animated: true, completion: {
            
            // Work around for iOS Version 10.1 (fixed in 10.2 beta)
            // In all other iOS versions, transform can be set before the camera is presented
            let transform = CGAffineTransform(translationX: 0.0, y: 100.0)
            self.ip!.cameraViewTransform = transform
            self.navigationController?.pushViewController(friendChallengeList, animated: true)
        })
        
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        ip!.takePicture()
    }
    
    @IBAction func doneTakingPhoto(_ sender: UIBarButtonItem) {
        ip?.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
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
        tableView.refreshControl?.endRefreshing()
    }
    
    func cellDrawButtonPressed(button : UIButton){
        
        let dvc: DrawViewController = DrawViewController(nibName: "DrawViewController",
                                                         bundle: Bundle.main)
        
        let challenge: Challenge?
        switch(segmentedControl.selectedSegmentIndex) {
        
        case 0: // User Challenges
            challenge = UserDatabase.global.John().challenges![button.tag]
        case 1: // Friend Challenges
            challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: UserDatabase.global.John().name,
                                                               atIndex: button.tag)
        default:
            challenge = nil
        }
        
        navigationController?.pushViewController(dvc, animated: true)
        dvc.loadViewIfNeeded()
        dvc.drawingView.setBackground(withImage: challenge?.image)
    }
    
    func cellVoteButtonPressed(button: UIButton) {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let challenge : Challenge?
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0: // User Challenges
            challenge = UserDatabase.global.John().challenges![button.tag]
        case 1: // Friend Challenges
            challenge = UserDatabase.global.GetFriendChallenge(forUserWithName: UserDatabase.global.John().name,
                                                               atIndex: button.tag)
        default:
            challenge = nil
        }
        
        selectedRow = IndexPath(row: button.tag, section: 0)
        let svc = SubmissionsViewController(collectionViewLayout: layout, withChallenge: challenge!)
        navigationController?.pushViewController(svc, animated: true)
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
