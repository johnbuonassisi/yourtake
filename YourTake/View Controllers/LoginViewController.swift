//
//  LoginViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-03.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

private let MinimumNumberOfCharactersForUser = 5
private let MinimumNumberOfCharactersForPassword = 6

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    // Outlets are "Implicitly Unwrapped Optional Properties"
    // AKA, they are assumed to not be nil and therefore
    // do not need to be unwrapped when used
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton! //
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Initializers
    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        

        if !checkLoginParams() {
            return
        }
        
        let isLoginSuccessful = UserDatabase.global.Login(username: userTextField!.text!,
                                                          password: passwordTextField!.text!)
        if isLoginSuccessful {
            
            // Present user with an alert and dismiss alert after 3 seconds
            let alert = UIAlertController(title: "Yay!",
                                          message: "You were successfully logged in",
                                          preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            let time = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                alert.dismiss(animated: true, completion:{
                    _ = self.navigationController?.popViewController(animated: true)
                })
            })
        } else {
            
            presentAlert(withTitle: "Ooops!",
                         withMessage: "Login failed, check your user name or password",
                         withActionTitle: "Let me try again")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        // present the sign-up view controller
        let signUpVc = SignUpViewController()
        navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        // present the forgot password view controller
    }
    
    @IBAction func dismissKeyboard() {
        
        loginButton.isEnabled = true
        forgotPasswordButton.isEnabled = true
        signUpButton.isEnabled = true
        
        view.endEditing(true)
    }
    
    // MARK: Private Methods
    
    private func checkLoginParams() -> Bool {
        
        if userTextField.text == nil ||
            passwordTextField.text == nil {
            
            presentAlert(withTitle: "Sorry our bad!",
                         withMessage: "An unexpected error occurred during login",
                         withActionTitle: "Please try again, or flag a bug")
            return false
        }
        
        if userTextField.text!.characters.count < MinimumNumberOfCharactersForUser {
            
            var messageString = "You entered an invalid user name"
            if userTextField.text!.characters.count == 0 {
                messageString = "You didn't enter a user name or email address"
            }
            presentAlert(withTitle: "Ooops!",
                         withMessage: messageString,
                         withActionTitle: "Let me try again")
            return false
        }
        
        if passwordTextField.text!.characters.count < MinimumNumberOfCharactersForPassword {
            presentAlert(withTitle: "Ooops!",
                         withMessage: "The password you entered was too short",
                         withActionTitle: "Let me try again")
            return false
        }
        
        return true
    }
    
    private func presentAlert(withTitle title: String,
                              withMessage message: String,
                              withActionTitle actionTitle: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle,
                                   style: .default,
                                   handler: {
                                    (action: UIAlertAction!) in alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate Extension

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        loginButton.isEnabled = false
        forgotPasswordButton.isEnabled = false
        signUpButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard()
        return true
    }
}
