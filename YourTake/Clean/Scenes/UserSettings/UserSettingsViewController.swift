//
//  UserSettingsViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {

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
    print("Add Friends!")
  }
  
  private func changeEmail() {
    print("Change Email!")
  }
  
  private func changePassword() {
    print("Change Password!")
  }
  
  private func signout() {
    
    let alert = UIAlertController(title: "", message: "Logging out...", preferredStyle: .alert)
    self.present(alert, animated: true, completion: nil)
    
    // Wait until all backend upload operations are complete, not doing so will cause permission problems
    DispatchQueue.global(qos: .background).async {
      let backend = Backend.sharedInstance
      while !backend.challengesInProgress.isEmpty || !backend.takesInProgress.isEmpty { sleep(1) }
      
      sleep(1)
      alert.dismiss(animated: true, completion:{
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
          let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
          let suvc = mainStoryBoard.instantiateViewController(withIdentifier: "Signup")
          let navVc = UINavigationController(rootViewController: suvc)
          UIApplication.shared.keyWindow?.rootViewController = navVc
        }
      })
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
