//
//  PasswordVerificationViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-08.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PasswordVerificationViewControllerInput {
    func displaySomething(viewModel: PasswordVerification.VerifyPassword.ViewModel)
}

protocol PasswordVerificationViewControllerOutput {
    func verifyPassword(request: PasswordVerification.VerifyPassword.Request)
    func validatePassword(request: PasswordVerification.VerifyPassword.Request)
}

class PasswordVerificationViewController: UIViewController, PasswordVerificationViewControllerInput {

    var output: PasswordVerificationViewControllerOutput!
    var router: PasswordVerificationRouter!

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PasswordVerificationConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Event handling
    
    @IBAction func currentPasswordChanged(_ sender: Any) {
        let request = PasswordVerification.VerifyPassword.Request(password: currentPasswordTextField.text!)
        output.validatePassword(request: request)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let request = PasswordVerification.VerifyPassword.Request(password: currentPasswordTextField.text!)
        output.verifyPassword(request: request)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        router.navigateToResetPasswordScene()
    }
    
    // MARK: - Display logic

    func displaySomething(viewModel: PasswordVerification.VerifyPassword.ViewModel) {
        // NOTE: Display the result from the Presenter
        continueButton.isEnabled = viewModel.isContinueButtonEnabled
        continueButton.backgroundColor = viewModel.continueButtonColour
        
        if viewModel.isPasswordVerified {
            router.navigateToChangePasswordScene()
        } else {
            if let alertModel = viewModel.alertModel {
                _ = router.presentAlert(title: alertModel.title,
                                    message: alertModel.message,
                                    actionTitle: alertModel.actionTitle)
                currentPasswordTextField.text = nil
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
