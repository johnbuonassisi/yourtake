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
        navigationItem.rightBarButtonItem = rbbi
    
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
            cell.challengeImage.image = UserDatabase.global.John().challenges![indexPath.row].image
            cell.name.text = UserDatabase.global.John().name
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
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 180, height: 180)
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
}
