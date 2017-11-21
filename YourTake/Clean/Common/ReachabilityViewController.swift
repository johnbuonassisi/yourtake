//
//  ReachabilityViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-20.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ReachabilityViewController: UIViewController {

    private let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }

}
