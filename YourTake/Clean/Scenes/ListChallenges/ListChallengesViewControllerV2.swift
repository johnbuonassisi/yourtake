//
//  ListChallengesViewControllerV2.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-04.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UIKit

protocol ListChallengesViewControllerInput {
    func displayFetchedChallenges(viewModel: ListChallenges.FetchChallenges.ViewModel)
}

protocol ListChallengesViewControllerOutput {
    func fetchChallenges(request: ListChallenges.FetchChallenges.Request)
}

class ListChallengesViewControllerV2: ReachabilityViewController,
    UITableViewDelegate,
    ListChallengesTableViewDataSourceDelegate,
    ListChallengesNoFriendsTableViewDataSourceDelegate,
    ListChallengesNoChallengesTableViewDataSourceDelegate,
    ListChallengesViewControllerInput {
    
    // MARK: - Object lifecycle
    
    var output: ListChallengesViewControllerOutput!
    var router: ListChallengesRouter!
    
    var challengesDataSource = ListChallengesTableViewDataSource()
    var noChallengesDataSource = ListChallengesNoChallengesTableViewDataSource()
    var noFriendsDataSource = ListChallengesNoFriendsTableViewDataSource()
    
    var challengeRequestType: ListChallenges.ChallengeRequestType = .userChallenges
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFriendsBarButton: UIBarButtonItem!
    @IBOutlet weak var createChallengeBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ListChallengesConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challengesDataSource.delegate = self
        noChallengesDataSource.delegate = self
        noFriendsDataSource.delegate = self
        
        tableView.dataSource = challengesDataSource
        tableView.delegate = self
        tableView.rowHeight = UIScreen.main.bounds.size.height
        tableView.allowsSelection = false
        
        let ctNib = UINib(nibName: "ChallengeTableViewCell", bundle: nil)
        tableView.register(ctNib, forCellReuseIdentifier: ListChallengeSceneCellIdentifiers.userChallengeCellId)
        tableView.register(ctNib, forCellReuseIdentifier: ListChallengeSceneCellIdentifiers.friendChallengeCellId)
        
        let ectNib = UINib(nibName: "EmptyChallengeTableViewCell", bundle: nil)
        tableView.register(ectNib, forCellReuseIdentifier: ListChallengeSceneCellIdentifiers.noChallengeCellId)
        
        let nftNib = UINib(nibName: "NoFriendsCell", bundle: nil)
        tableView.register(nftNib, forCellReuseIdentifier: ListChallengeSceneCellIdentifiers.noFriendsCellId)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.refreshControl!.beginRefreshing()
        
        tableView.rowHeight = ChallengeTableViewCell.getHeightofCell(for: UIScreen.main.bounds.size.width)
        
        fetchChallengesOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // TODO - Use this method to trigger actions when the network is not available
    override func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi in List Challenges Scene")
        case .cellular:
            print("Reachable via Cellular in List Challenges Scene")
        case .none:
            print("Network not reachable in List Challenges Scene")
        }
    }
    
    // MARK: - Event handling
    
    func fetchChallengesOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = ListChallenges.FetchChallenges.Request(challengeType: challengeRequestType,
                                                             isChallengeAndImageLoadSeparated: false)
        output.fetchChallenges(request: request)
    }
    
    // MARK: - Display logic
    
    func displayFetchedChallenges(viewModel: ListChallenges.FetchChallenges.ViewModel) {
        // NOTE: Display the result from the Presenter
        switch(viewModel.challengeType) {
        case .userChallenges:
            challengesDataSource.displayedChallenges = viewModel.displayedChallenges
            tableView.dataSource = challengesDataSource
        case .friendChallenges:
            challengesDataSource.displayedChallenges = viewModel.displayedChallenges
            tableView.dataSource = challengesDataSource
        case .noChallenges:
            tableView.dataSource = noChallengesDataSource
        case .noFriends:
            tableView.dataSource = noFriendsDataSource
        }
        
        createChallengeBarButton.isEnabled = viewModel.isChallengeCreationEnabled
        tableView.reloadData()
        tableView.refreshControl!.endRefreshing()
    }
    
    // MARK - Action methods
    
    func drawOnChallenge(inRow row: Int) {
        let challengeId = challengesDataSource.displayedChallenges[row].id
        let challengeImage = challengesDataSource.displayedChallenges[row].challengeImage
        router.navigateToCreateTakeScene(challengeId: challengeId, challengeImage: challengeImage!)
    }
    
    func voteOnChallenge(inRow row: Int) {
        let challengeId = challengesDataSource.displayedChallenges[row].id
        router.navigateToTakesScene(with: challengeId)
    }
    
    @IBAction func createChallenge(_ sender: Any) {
        router.navigateToSnapChallengeImageScene()
    }
    
    @IBAction func viewFriendsManagement(_ sender: Any) {
        router.navigateToFriendManagementScene()
    }
    
    func refresh(sender: UIButton!) {
        let request = ListChallenges.FetchChallenges.Request(challengeType: challengeRequestType,
                                                             isChallengeAndImageLoadSeparated: true)
        output.fetchChallenges(request: request)
    }
}

