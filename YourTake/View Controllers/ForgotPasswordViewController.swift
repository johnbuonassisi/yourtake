//
//  ForgotPasswordViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-12-07.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    init() {
        super.init(nibName: "ForgotPasswordViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailAddressTextField.delegate = self
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        
        // reset password for specified email address
        let isPasswordReset = UserDatabase.global.ResetPassword(username: emailAddressTextField.text!)
        
        if isPasswordReset {
            presentAlertAndPop(withTitle: "Your password was reset",
                               withMessage: "We have sent you an email containing your new password.",
                               withActionTitle: "Dismiss")
        } else {
            presentAlert(withTitle: "Ooops!",
                         withMessage: "Something went wrong, try again",
                         withActionTitle: "Let me try again")
        }
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func presentAlertAndPop(withTitle title: String,
                              withMessage message: String,
                              withActionTitle actionTitle: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle,
                                   style: .default,
                                   handler: {
                                    (action: UIAlertAction!) in
                                    alert.dismiss(animated: true, completion: nil)
                                    _ = self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
