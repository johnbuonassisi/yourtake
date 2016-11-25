//
//  SubmissionsViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-02.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class SubmissionsViewController: UICollectionViewController
{
    // MARK: Member Variables
    
    let challenge : Challenge?
    
    // MARK: Initializers
    
    init(collectionViewLayout layout: UICollectionViewLayout,
         withChallenge challenge: Challenge) {
        
        self.challenge = challenge
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.challenge = nil
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib : UINib = UINib(nibName: "SubmissionsCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "SubmissionCell")
        
        collectionView?.backgroundColor = UIColor.white
        
        // Setup the navigation bar
        navigationItem.title = "Takes"
        
    }
    
    // MARK: UICollectionViewDelegate Methods
    
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
        fullImage.frame = CGRect(x: 0,
                                 y: navigationController!.navigationBar.frame.height,
                                 width: collectionView.frame.width,
                                 height: collectionView.frame.width)
        vc.view.backgroundColor = UIColor.white
        vc.view.addSubview(fullImage)
        vc.navigationItem.title = submission.name
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: Action Methods
    
    @IBAction func submissionsCellVoteButtonPressed(button: UIButton) {
        
        let cell : SubmissionsCell = button.superview?.superview?.superview as! SubmissionsCell
        challenge!.voteFor(user: cell.submitterName.text!, byVoter: "John")
        self.collectionView?.reloadData()
    }

}

// MARK: Layout Extension

extension SubmissionsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // return the width and height of the collection view cell
        return CGSize(width: (collectionView.frame.width - 3*5) / 2,
                      height: ((collectionView.frame.width - 3*5) / 2) + 35)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // return the margins to apply to content in the specified section
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        // return the spacing between successive rows or columns of a section
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        // return the spacing between successive items in the rows or columns of a section
        return 5.0
    }
    
}
