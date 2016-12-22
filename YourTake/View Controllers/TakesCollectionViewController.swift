//
//  TakesCollectionViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-02.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class TakesCollectionViewController: UICollectionViewController
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
        
        let nib : UINib = UINib(nibName: "TakeCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "TakeCell")
        
        collectionView?.backgroundColor = UIColor.white
        
        // Setup the navigation bar
        navigationItem.title = "Takes"
        
        // Sort the takes
        challenge?.sortTakes()
        
    }
    
    // MARK: UICollectionViewDelegate Methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenge!.takes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TakeCell",
                                                                      for: indexPath) as! TakeCell
        cell.voteButton.tag = indexPath.row
        cell.voteButton.addTarget(self,
                                  action: #selector(takeCellVoteButtonPressed),
                                  for: UIControlEvents.touchUpInside)
        
        let take = challenge!.takes[indexPath.row] // The data source has the challenges pre-sorted
        
        cell.image.image = take.image
        cell.submitterName.text = take.name
        cell.numberOfVotes.text = String(challenge!.getNumberOfVotes(forUser: take.name))
        if(challenge!.getVoteOf(user : "John") == take.name)
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
        
        let take = challenge!.takes[indexPath.row]
        
        // Hardcode
        let vc = UIViewController()
        let fullImage = UIImageView(image:take.image)
        fullImage.frame = CGRect(x: 0,
                                 y: navigationController!.navigationBar.frame.height,
                                 width: collectionView.frame.width,
                                 height: collectionView.frame.width)
        vc.view.backgroundColor = UIColor.white
        vc.view.addSubview(fullImage)
        vc.navigationItem.title = take.name
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: Action Methods
    
    @IBAction func takeCellVoteButtonPressed(button: UIButton) {
        
        if challenge!.isExpired() {
            return
        }
        
        let cell = button.superview?.superview?.superview as! TakeCell
        challenge!.voteFor(user: cell.submitterName.text!,
                           byVoter: "John",
                           andSort: false) // Don't allow the model to sort the takes at this point
                                           // Sorting is only done when the view is loaded
        self.collectionView?.reloadData()
    }

}

// MARK: Layout Extension

extension TakesCollectionViewController : UICollectionViewDelegateFlowLayout {
    
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
