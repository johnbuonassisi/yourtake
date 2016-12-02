//
//  SignUpViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-12-01.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

private let MinimumPasswordSize = 8

class SignUpViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var joinUsButton: UIButton!
    
    @IBOutlet weak var emailAddressSwitch: UISwitch!
    @IBOutlet weak var userNameSwitch: UISwitch!
    @IBOutlet weak var passwordSwitch: UISwitch!
    @IBOutlet weak var confirmPasswordSwitch: UISwitch!
    
    // MARK: Initializers
    init() {
        super.init(nibName: "SignUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        
        emailAddressTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Sign Up"
    }
    
    
    // MARK: Actions
    @IBAction func joinUsButtonPressed(_ sender: UIButton) {
        let isRegistered = UserDatabase.global.Register(username: userNameTextField.text!,
                                                        password: passwordTextField.text!)
        if isRegistered {
            
            // Present user with an alert and dismiss alert after 3 seconds
            let alert = UIAlertController(title: "Welcome to YourTake!",
                                          message: "Your signup was successful",
                                          preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            
            let time = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                alert.dismiss(animated: true, completion:{
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            })
            
            _ = navigationController?.popToRootViewController(animated: true)
            
        } else {
            presentAlert(withTitle: "Ooops!",
                         withMessage: "Unable to sign up",
                         withActionTitle: "Let me try again")
        }
    }
    
    @IBAction func emailAddressTextFieldChanged(_ sender: UITextField) {
        
        if isValidEmail(emailAddress: sender.text!) {
            emailAddressSwitch.setOn(true, animated: true)
        }
        else {
            emailAddressSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func userNameTextFieldChanged(_ sender: UITextField) {
        
        if sender.text!.characters.count > 5 {
            userNameSwitch.setOn(true, animated: true)
        }
        else {
            userNameSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        
        if sender.text!.characters.count >= MinimumPasswordSize {
            passwordSwitch.setOn(true, animated: true)
        }
        else {
            passwordSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func confirmPasswordTextFieldChanged(_ sender: UITextField) {
        
        if sender.text!.characters.count >= MinimumPasswordSize &&
           sender.text! == passwordTextField.text! {
            confirmPasswordSwitch.setOn(true, animated: true)
        } else {
            confirmPasswordSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func dismissKeyboard() {
        
        if emailAddressSwitch.isOn && userNameSwitch.isOn &&
            passwordSwitch.isOn && confirmPasswordSwitch.isOn {
            joinUsButton.isEnabled = true
        }
        view.endEditing(true)
    }
    
    // MARK: Private Methods
    private func checkSignUpParams() -> Bool {
        
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
    
    private func isValidEmail(emailAddress: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
}

// MARK: UITextFieldDelegate Extension

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        joinUsButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}
