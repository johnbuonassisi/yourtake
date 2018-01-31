//
//  DisplayTakeVotersTableViewDataSource.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-29.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UIKit

class DisplayTakeVotersTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var voters = [String]()
    
    required init(voters: Set<String>) {
        self.voters = Array(voters).sorted() // convert set to array of strings sorted alphabetically
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Voters (\(voters.count))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayTakeCellIdentifiers.votersCellId)!
        cell.textLabel?.text = voters[indexPath.row]
        return cell
    }
}
