//
//  SettingsViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-12-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        
        case 0: // Account
            
            switch indexPath.row {
            
            case 0:
                addFriends()
            case 1:
                changeEmail()
            case 2:
                changePassword()
            case 4:
                signout()
            default:
                return
            }
        
        case 1: // Information
            
            switch indexPath.row {
            
            case 0:
                showAboutUs()
            case 1:
                goToSupportCentre()
            case 2:
                showPrivacyPolicy()
            case 3:
                showTermsOfService()
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func notificationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Notifications are enabled")
        } else {
            print("Notifications are disabled")
        }
    }
    
    
    private func addFriends() {
        print("Add Friends")
    }
    
    private func changeEmail() {
        print("Change Email")
    }
    
    private func changePassword() {
        print("Change Password")
    }
    
    private func signout() {
        
        // do not allow cancelling a logout attempt
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Logging out..."
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 75)
        label.textAlignment = .center
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        activityIndicator.center = view.center
        
        let overlay = UIView()
        overlay.frame = view.frame
        overlay.center = view.center
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        overlay.addSubview(label)
        overlay.addSubview(activityIndicator)
        self.view.addSubview(overlay)
        
        // Wait until all backend upload operations are complete, not doing so will cause permission problems
        DispatchQueue.global(qos: .background).async {
            // disable all UI interactions
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // start overlay animation
            DispatchQueue.main.async {
                // add activity overlay indicator to view
                activityIndicator.startAnimating()
            }
            
            let backend = Backend.sharedInstance
            while !backend.challengesInProgress.isEmpty || !backend.takesInProgress.isEmpty {}
            activityIndicator.stopAnimating()
            
            // Delete the username and password from the keychain
            do {
                let passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
                for item in passwordItems {
                    try item.deleteItem()
                }
            } catch {
                fatalError("Error deleting password items - \(error)")
            }
            
            // change to signup view
            DispatchQueue.main.async {
                // Replace the current View Controllers in the Navigation Controller with new ones
                // This wipes out data stored in the Challenge View Controller
                let suvc = SignUpViewController()
                let cvc = ChallengeViewController(nibName: "ChallengeViewController", bundle: Bundle.main)

                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.setViewControllers([cvc, suvc], animated: true)
            }
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func showAboutUs() {
        print("Show About Us")
    }
    
    private func goToSupportCentre() {
        print("Go To Support Centre")
    }
    
    private func showPrivacyPolicy() {
        print("Show Privacy Policy")
    }
    
    private func showTermsOfService() {
        print("Show Terms Of Service")
    }

}
