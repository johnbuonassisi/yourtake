//
//  DisplayTakeViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-14.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class DisplayTakeViewController: UIViewController {
    
    @IBOutlet weak var takeImageView: UIImageView!
    @IBOutlet weak var votersTableView: UITableView!
    
    private let displayedViewModel: DisplayTake.ViewModel
    private let votersTableViewDataSource: DisplayTakeVotersTableViewDataSource
    
    init(viewModel: DisplayTake.ViewModel) {
        self.displayedViewModel = viewModel
        self.votersTableViewDataSource = DisplayTakeVotersTableViewDataSource(voters: viewModel.voters)
        super.init(nibName: "DisplayTakeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.takeImageView.image = displayedViewModel.takeImage
        self.navigationItem.title = displayedViewModel.author
        self.votersTableView.register(UITableViewCell.self, forCellReuseIdentifier: DisplayTakeCellIdentifiers.votersCellId)
        self.votersTableView.dataSource = votersTableViewDataSource
        self.votersTableView.allowsSelection = false
    }
}
