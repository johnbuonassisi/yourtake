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
                               UIImagePickerControllerDelegate{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow : IndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        // Load and register cell NIB
        let nib : UINib = UINib(nibName: "ChallengeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChallengeCellTest")
        
        // Set the cell height
        tableView.rowHeight = ChallengeCell.CellRowHeight()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Setup the navigation bar
        navigationItem.title = "Challenges"
        
        let rbbi = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera,
                                   target: self,
                                   action: #selector(ChallengeViewController.newChallenge))
        
        let lbbi = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks,
                                   target: self,
                                   action: nil)
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.leftBarButtonItem = lbbi
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Reload a row that was previously selected
        if selectedRow != nil
        {
            tableView.reloadRows(at: [selectedRow!], with: UITableViewRowAnimation.none)
            selectedRow = nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(segmentedControl.selectedSegmentIndex){
        
        case 0: // User Challenges
            return UserDatabase.global.John().challenges!.count
            
        case 1: // Friend Challenges
            return 0
            
        default: // ??
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(segmentedControl.selectedSegmentIndex){
        
        case 0: // User Challenges
            let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCellTest",
                                                                     for: indexPath) as! ChallengeCell
            let john = UserDatabase.global.John()
            let johnsChallenges = john.challenges![indexPath.row]
            
            cell.challengeImage.image = johnsChallenges.image
            cell.name.text = john.name
            cell.expiryLabel.text = getExpiryLabel(fromDate: johnsChallenges.expiryDate as Date)
            cell.totalVotesLabel.text = String(johnsChallenges.getTotalVotes()) + " total votes"
            
            return cell
            
        case 1: // Friend Challenges
            let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCellTest",
                                                                     for: indexPath) as! ChallengeCell
            cell.challengeImage.image = UserDatabase.global.John().challenges![0].image
            cell.name.text = UserDatabase.global.John().name
            return cell
            
        default: // ??
            let cell : ChallengeCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCellTest",
                                                                     for: indexPath) as! ChallengeCell
            cell.challengeImage.image = UserDatabase.global.John().challenges![0].image
            cell.name.text = UserDatabase.global.John().name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath // Save the row that was selected before push a new vc
        
        // Hardcode
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 180, height: 215)
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5)
        
        let svc = SubmissionsViewController(collectionViewLayout: layout, challengeIndex: indexPath.row)
        navigationController?.pushViewController(svc, animated: true)
    }
    
    @IBAction func segmentChanges(_ sender: UISegmentedControl)
    {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func newChallenge()
    {
        let ip : UIImagePickerController = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            ip.sourceType = UIImagePickerControllerSourceType.camera
        }
        else
        {
            ip.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        ip.delegate = self
        self.present(ip, animated: true, completion: nil)
        
    }
    
    private func getExpiryLabel(fromDate date: Date) -> String
    {
        let numSecondsRemaining : Int = Int(date.timeIntervalSince(Date()))
        
        let numDaysRemaining = numSecondsRemaining / ( 60 * 60 * 24)
        if(numDaysRemaining > 0)
        {
            if numDaysRemaining == 1 {
                return String(numDaysRemaining) + " day remaining"
            }
            return String(numDaysRemaining) + " days remaining"
        }
        
        let numHoursRemaining = numSecondsRemaining / ( 60 * 60 )
        if( numHoursRemaining > 0)
        {
            if numHoursRemaining == 1 {
                return String(numHoursRemaining) + "hour remaining"
            }
            return String(numHoursRemaining) + " hours remaining"
        }
        
        let numMinutesRemaining = numSecondsRemaining / 60
        if(numMinutesRemaining > 0)
        {
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
