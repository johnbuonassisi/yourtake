//
//  DisplayTakeViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-14.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class DisplayTakeViewController: UIViewController{

  
  @IBOutlet weak var takeImageView: UIImageView!
  @IBOutlet weak var likeImageView: UIImageView!
  @IBOutlet weak var numberOfVotesLabel: UILabel!
  
  let displayedViewModel: DisplayTake.ViewModel
  
  init(viewModel: DisplayTake.ViewModel) {
    self.displayedViewModel = viewModel
    super.init(nibName: "DisplayTakeViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    takeImageView.image = displayedViewModel.takeImage
    likeImageView.image = displayedViewModel.likeButtonImage
    numberOfVotesLabel.text = displayedViewModel.numberOfVotes
    
    self.navigationItem.title = displayedViewModel.author
  }
  
}
