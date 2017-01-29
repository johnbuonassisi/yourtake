//
//  LoginViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-03.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

private let MinimumPasswordSize = 8

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    // Outlets are "Implicitly Unwrapped Optional Properties"
    // AKA, they are assumed to not be nil and therefore
    // do not need to be unwrapped when used
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var passwordSwitch: UISwitch!
    
    // MARK: Initializers
    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        
        usernameTextField.delegate = self
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
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.login(username: usernameTextField!.text!, password: passwordTextField!.text!, completion: { (success) -> Void in
            if success {
                // Present user with an alert and dismiss alert after 3 seconds
                let alert = UIAlertController(title: "Yay!",
                                              message: "You were successfully logged in",
                                              preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                let time = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    alert.dismiss(animated: true, completion:{
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    })
                })
            } else {
                self.presentAlert(withTitle: "Ooops!",
                             withMessage: "Something went wrong, try again",
                             withActionTitle: "Let me try again")
            }
        })
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        let forgotPasswordVc = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVc, animated: true)
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        
        if sender.text!.characters.count >= MinimumPasswordSize {
            passwordSwitch.setOn(true, animated: true)
        }
        else {
            passwordSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func dismissKeyboard() {
        
        loginButton.isEnabled = true
        forgotPasswordButton.isEnabled = true
        signUpButton.isEnabled = true
        
        view.endEditing(true)
    }
    
    // MARK: Private Methods
    
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard()
        return true
    }
}
