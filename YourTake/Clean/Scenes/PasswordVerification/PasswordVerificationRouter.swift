//
//  PasswordVerificationRouter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-08.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PasswordVerificationRouterInput {
    func navigateToChangePasswordScene()
    func navigateToResetPasswordScene()
}

class PasswordVerificationRouter: AlertPresenter, PasswordVerificationRouterInput {

    // MARK: - Navigation

    func navigateToChangePasswordScene() {
        viewController.performSegue(withIdentifier: PasswordVerificationSceneSegueIds.changePasswordSegue,
                                    sender: viewController)
    }
    
    func navigateToResetPasswordScene() {
        viewController.performSegue(withIdentifier: PasswordVerificationSceneSegueIds.resetPasswordSegue,
                                    sender: nil)
    }

    // MARK: - Communication

    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with

        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue: segue)
        }
    }

    func passDataToSomewhereScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene

        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.output.name = viewController.output.name
    }
}
