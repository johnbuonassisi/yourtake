//
//  SubmissionsViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-02.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class SubmissionsViewController: UICollectionViewController{
    
    let challenge : Challenge?
    
    init(collectionViewLayout layout: UICollectionViewLayout, withChallenge challenge: Challenge)
    {
        self.challenge = challenge
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.challenge = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib : UINib = UINib(nibName: "SubmissionsCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "SubmissionCell")
        
        collectionView?.backgroundColor = UIColor.white
        
        // Setup the navigation bar
        navigationItem.title = "Submissions"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenge!.submissions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SubmissionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmissionCell",
                                                                        for: indexPath) as! SubmissionsCell
        cell.voteButton.addTarget(self,
                                  action: #selector(submissionsCellVoteButtonPressed),
                                  for: UIControlEvents.touchUpInside)
        
        let submission = challenge!.submissions[indexPath.row] // The data source has the challenges pre-sorted
        
        cell.submissionImage.image = submission.image
        cell.submitterName.text = submission.name
        cell.numberOfVotes.text = String(challenge!.getNumberOfVotes(forUser: submission.name))
        if(challenge!.getVoteOf(user : "John") == submission.name)
        {
            let likedImage = UIImage(named: "Liked", in: nil, compatibleWith: nil)
            cell.voteButton.setImage(likedImage, for: UIControlState.normal)
        }
        else
        {
            let notLikedImage = UIImage(named: "NotLiked", in: nil, compatibleWith: nil)
            cell.voteButton.setImage(notLikedImage, for: UIControlState.normal)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let submission = challenge!.submissions[indexPath.row]
        
        // Hardcode
        let vc = UIViewController()
        let fullImage = UIImageView(image:submission.image)
        fullImage.frame = CGRect(x: 0, y: 150, width: 375, height: 375)
        vc.view.backgroundColor = UIColor.white
        vc.view.addSubview(fullImage)
        vc.navigationItem.title = submission.name
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func submissionsCellVoteButtonPressed(button: UIButton)
    {
        let cell : SubmissionsCell = button.superview?.superview?.superview as! SubmissionsCell
        challenge!.voteFor(user: cell.submitterName.text!, byVoter: "John")
        self.collectionView?.reloadData()
    }

}
