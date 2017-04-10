//
//  ListTakesCollectionViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-08.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ListTakesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  
  var displayedTakes: [ListTakes.FetchTakes.ViewModel.DisplayedTake] = []
  weak var viewController: ListTakesViewController!
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayedTakes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TakeCollectionViewCell", for: indexPath) as! TakeCollectionViewCell
    
    let displayedTake = displayedTakes[indexPath.row]
    
    cell.authorLabel.text = displayedTake.author
    cell.numberOfVotesLabel.text = displayedTake.numberOfVotes
    cell.takeImage.image = displayedTake.takeImage
    cell.likeButton.setImage(displayedTake.likeButtonImage, for: .normal)
    
    cell.likeButton.addTarget(viewController,
                              action: #selector(viewController.cellVoteButtonPressed),
                              for: .touchUpInside)
    cell.likeButton.tag = indexPath.row
    
    return cell
  }

}
