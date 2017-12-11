//
//  ListTakesViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-08.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListTakesViewControllerInput {
    func displayTakes(viewModel: ListTakes.FetchTakes.ViewModel)
}

protocol ListTakesViewControllerOutput {
    func fetchTakes(request: ListTakes.FetchTakes.Request)
    func voteForTake(request: ListTakes.VoteForTake.Request)
}

class ListTakesViewController: UICollectionViewController, ListTakesViewControllerInput {
    var output: ListTakesViewControllerOutput!
    var router: ListTakesRouter!
    
    var listTakesDataSource = ListTakesCollectionViewDataSource()
    
    let challengeId: String
    
    // MARK: - Object lifecycle
    
    init(challengeId: String) {
        
        self.challengeId = challengeId
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        super.init(collectionViewLayout: layout)
        
        ListTakesConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.dataSource = listTakesDataSource
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.refreshControl = UIRefreshControl()
        self.collectionView?.refreshControl?.beginRefreshing()
        self.collectionView?.refreshControl?.attributedTitle = NSAttributedString(string: "")
        self.collectionView?.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        self.navigationItem.title = "Takes"
        
        let nib = UINib(nibName: "TakeCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "TakeCollectionViewCell")
        
        fetchTakesOnLoad()
    }
    
    // MARK: - Event handling
    
    func fetchTakesOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = ListTakes.FetchTakes.Request(challengeId: challengeId)
        output.fetchTakes(request: request)
    }
    
    func refresh() {
        fetchTakesOnLoad()
    }
    
    // MARK: - Display logic
    
    func displayTakes(viewModel: ListTakes.FetchTakes.ViewModel) {
        // NOTE: Display the result from the Presenter
        listTakesDataSource.displayedTakes = viewModel.displayedTakes
        collectionView?.reloadData()
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    func cellVoteButtonPressed(sender: UIButton!) {
        let request = ListTakes.VoteForTake.Request(takeTag: sender.tag)
        output.voteForTake(request: request)
    }
    
    func cellTakeImagePressed(sender: UIButton!) {
        let listTakeViewModel = listTakesDataSource.displayedTakes[sender.tag]
        router.navigateToDisplayTakeScene(listTakesViewModel: listTakeViewModel)
    }
    
}

// MARK: Layout Extension

extension ListTakesViewController : UICollectionViewDelegateFlowLayout {
    
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
