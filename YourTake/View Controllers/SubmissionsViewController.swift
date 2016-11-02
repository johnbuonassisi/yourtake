//
//  SubmissionsViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-02.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class SubmissionsViewController: UICollectionViewController{
    
    var challengeIndex : Int?
    
    init(collectionViewLayout layout: UICollectionViewLayout, challengeIndex index:Int) {
        
        challengeIndex = index
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        challengeIndex = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib : UINib = UINib(nibName: "SubmissionsCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "SubmissionCell")
        
        collectionView?.backgroundColor = UIColor.blue
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDatabase.global.John().challenges![challengeIndex!].submissions!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SubmissionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmissionCell",
                                                                        for: indexPath) as! SubmissionsCell
        
        cell.submissionImage.image = UserDatabase.global.John().challenges![challengeIndex!].submissions![indexPath.row]
        cell.submitterName.text = UserDatabase.global.John().challenges![challengeIndex!].friends[indexPath.row]
        return cell
    }

}
