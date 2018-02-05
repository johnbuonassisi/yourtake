//
//  UserForLoginPasswordViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class UserForgotLoginPasswordViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = false
    
    let tap = UITapGestureRecognizer(target: self,
                                     action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
    
    emailAddressTextField.delegate = self
  }
  
  @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
    
    sender.isEnabled = false
    sender.backgroundColor = Constants.SystemColours.lightGreyColour
    activityIndicator.startAnimating()
    
    // reset password for specified email address
    let backendClient = Backend.sharedInstance.getClient()
    
    backendClient.resetPassword(for: emailAddressTextField.text!, completion: { (success) -> Void in
      if success {
        self.presentAlert(withTitle: "Password reset email sent",
                                withMessage: "Check your email for instructions on how to reset your password",
                                withActionTitle: "Dismiss")
      } else {
        self.presentAlert(withTitle: "Ooops!",
                          withMessage: "Something went wrong",
                          withActionTitle: "Let me try again")
      }
        sender.isEnabled = true
        sender.backgroundColor = Constants.SystemColours.blueColour
        self.activityIndicator.stopAnimating()
    })
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    return true
  }

}
