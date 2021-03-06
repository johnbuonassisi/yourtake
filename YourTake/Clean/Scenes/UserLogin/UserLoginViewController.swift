//
//  UserLoginViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-15.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol UserLoginViewControllerInput
{
  func displayLogin(viewModel: UserLogin.Login.ViewModel)
}

protocol UserLoginViewControllerOutput
{
  func login(request: UserLogin.Login.Request, completion: ((Bool) -> Void)? )
}

class UserLoginViewController: UIViewController,
                               UITextFieldDelegate,
                               UserLoginViewControllerInput
{
  var output: UserLoginViewControllerOutput!
  var router: UserLoginRouter!
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var passwordSwitch: UISwitch!
  
  // MARK: - Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    UserLoginConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  // MARK: - Display logic
  
  func displayLogin(viewModel: UserLogin.Login.ViewModel)
  {
    // NOTE: Display the result from the Presenter
    loginButton.isEnabled = viewModel.isLoginButtonEnabled
    forgotPasswordButton.isEnabled = viewModel.isForgotPasswordButtonEnabled
    signUpButton.isEnabled = viewModel.isSignupButtonEnabled
    passwordSwitch.setOn(viewModel.isPasswordSwitchOn, animated: true)
    loginButton.backgroundColor = viewModel.loginButtonColour
  }
  
  // MARK: - Event Handling
  
  @IBAction func loginButtonPressed(_ sender: Any) {
    let request = UserLogin.Login.Request(username: usernameTextField.text!,
                                          password: passwordTextField.text!,
                                          requestType: .loginRequest)
    output.login(request: request, completion: { (isLoginSuccess) -> Void in
      if isLoginSuccess {
        self.router.navigateToChallengeScene()
      } else {
        self.router.presentAlert()
      }
    })
  }
  
  @IBAction func signupButtonPressed(_ sender: UIButton) {
    router.navigateToSignupScene()
  }
  
  
  @IBAction func passwordChanged(_ sender: Any, forEvent event: UIEvent) {
    let request = UserLogin.Login.Request(username: usernameTextField.text!,
                                          password: passwordTextField.text!,
                                          requestType: .updateView)
    output.login(request: request, completion: nil)
  }
  
  @IBAction func usernameChanged(_ sender: UITextField) {
    let request = UserLogin.Login.Request(username: usernameTextField.text!,
                                          password: passwordTextField.text!,
                                          requestType: .updateView)
    output.login(request: request, completion: nil)
  }
  
  func dismissKeyboard() {
    loginButton.isEnabled = true
    forgotPasswordButton.isEnabled = true
    signUpButton.isEnabled = true
    view.endEditing(true)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    loginButton.isEnabled = false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    return true
  }
  
  
}
