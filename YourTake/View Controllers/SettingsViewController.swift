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
