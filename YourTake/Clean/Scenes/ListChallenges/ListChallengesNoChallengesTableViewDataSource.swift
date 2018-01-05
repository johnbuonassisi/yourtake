//
//  ListChallengesNoChallengesTableViewDataSource.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-29.
//  Copyright © 2017 JAB. All rights reserved.
//

import UIKit

@objc protocol ListChallengesNoChallengesTableViewDataSourceDelegate: class {
    func createChallenge(_ sender: Any)
}

class ListChallengesNoChallengesTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: ListChallengesNoChallengesTableViewDataSourceDelegate!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ListChallengesScene.noChallengeCellId, for: indexPath) as! EmptyChallengeTableViewCell
        cell.createNewChallengeButton.addTarget(delegate,
                                                action: #selector(delegate.createChallenge),
                                                for: .touchUpInside)
        return cell
    }
}
