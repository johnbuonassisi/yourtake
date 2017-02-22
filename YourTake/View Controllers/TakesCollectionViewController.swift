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
    private var user: User?
    private let challenge: Challenge?
    private var takes = [Take]()
    
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
        
        // get initial data from source
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.getUser(completion: { (object) -> Void in self.user = object})
        backendClient.getTakes(for: challenge!.id, completion: { (objects) -> Void in
            self.takes = objects
            self.collectionView?.reloadData()
        })
    }
    
    // MARK: UICollectionViewDelegate Methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return takes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TakeCell",
                                                                      for: indexPath) as! TakeCell
        cell.voteButton.tag = indexPath.row
        cell.voteButton.addTarget(self,
                                  action: #selector(takeCellVoteButtonPressed),
                                  for: UIControlEvents.touchUpInside)
        
        var take: Take?
        if indexPath.row >= 0 && indexPath.row < takes.count {
            take = takes[indexPath.row]
        }
        
        cell.image.image = take!.overlay
        cell.submitterName.text = take!.author
        cell.numberOfVotes.text = String(take!.votes)
        if(user?.votes[challenge!.id] == take!.id)
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
        var take: Take?
        if indexPath.row >= 0 && indexPath.row < takes.count {
            take = takes[indexPath.row]
        }
        
        // Hardcode
        let vc = UIViewController()
        let fullImage = UIImageView(image:take!.overlay)
        fullImage.frame = CGRect(x: 0,
                                 y: navigationController!.navigationBar.frame.height,
                                 width: collectionView.frame.width,
                                 height: collectionView.frame.width)
        vc.view.backgroundColor = UIColor.white
        vc.view.addSubview(fullImage)
        vc.navigationItem.title = take!.author
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Action Methods
    
    @IBAction func takeCellVoteButtonPressed(index: Int) {
        var take: Take?
        if index >= 0 && index < takes.count {
            take = takes[index]
        }
        
        if take != nil {
            take!.vote()
        }
        
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
