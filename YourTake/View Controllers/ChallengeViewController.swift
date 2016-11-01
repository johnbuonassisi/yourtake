//
//  ChallengeViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-31.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController,
                               UITableViewDelegate,
                               UITableViewDataSource{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
        myCell.textLabel?.text = "Hello World!"
        return myCell
    }
}
