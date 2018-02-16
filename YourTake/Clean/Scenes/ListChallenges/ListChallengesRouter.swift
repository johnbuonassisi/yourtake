//
//  ListChallengesRouter.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright (c) 2017 JAB. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListChallengesRouterInput {
    func navigateToTakesScene(with challengeId: String)
}

class ListChallengesRouter: ListChallengesRouterInput {
    weak var viewController: ListChallengesViewController!
    var challengeId: String!
    // MARK: - Navigation
    
    func navigateToTakesScene(with challengeId: String) {
        print("Navigating to Take List Scene")
        self.challengeId = challengeId
        if viewController.challengeRequestType == .friendChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.FriendListChallengeScene.listTakesSegue,
                                        sender: nil)
        } else if viewController.challengeRequestType == .userChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.UserListChallengesScene.listTakesSegue,
                                        sender: nil)
        } else {
            print("Invalid challenge request type")
        }
    }
    
    func navigateToCreateTakeScene(challengeId: String, challengeImage: UIImage) {
        print("Navigating to Create Take Scene")
        let ctvc = CreateTakeViewController(challengeId: challengeId, challengeImage: challengeImage)
        ctvc.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(ctvc, animated: true)
    }
    
    func navigateToSnapChallengeImageScene() {
        print("Navigating to Snap Challenge Scene")
        if viewController.challengeRequestType == .friendChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.FriendListChallengeScene.photoPreviewSegue,
                                        sender: nil)
        } else if viewController.challengeRequestType == .userChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.UserListChallengesScene.photoPreviewSegue,
                                        sender: nil)
        } else {
            print("Invalid challenge request type")
        }
    }
    
    func navigateToFriendManagementScene() {
        print("Navigating to Add Friends Scene")
        if viewController.challengeRequestType == .friendChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.FriendListChallengeScene.friendManagementSegue,
                                        sender: nil)
        } else if viewController.challengeRequestType == .userChallenges {
            viewController.performSegue(withIdentifier: SegueIdentifiers.ListChallengesScene.UserListChallengesScene.friendManagementSegue,
                                        sender: nil)
        } else {
            print("Invalid challenge request type")
        }
    }
    
    // MARK: - Communication
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        
        if segue.identifier == SegueIdentifiers.ListChallengesScene.FriendListChallengeScene.listTakesSegue ||
            segue.identifier == SegueIdentifiers.ListChallengesScene.UserListChallengesScene.listTakesSegue {
            passDataToListTakesScene(segue: segue)
        }
    }
    
    func passDataToListTakesScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene
        
        let listTakesViewController = segue.destination as! ListTakesViewController
        listTakesViewController.challengeId = self.challengeId
    }
}
