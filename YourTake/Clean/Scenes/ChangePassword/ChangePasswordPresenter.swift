//
//  ChangePasswordPresenter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-09-04.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ChangePasswordPresenterInput {
    func presentSomething(response: ChangePassword.Response)
}

protocol ChangePasswordPresenterOutput: class {
    func displayPasswordChange(viewModel: ChangePassword.ViewModel)
}

class ChangePasswordPresenter: ChangePasswordPresenterInput {
    weak var output: ChangePasswordPresenterOutput!
    
    // MARK: - Presentation logic
    
    func presentSomething(response: ChangePassword.Response) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        var isPasswordChanged = false
        var alertModel: AlertModel?
        var isSaveButtonEnabled = true
        var saveButtonColour = Constants.SystemColours.blueColour
        
        switch response.responseType {
        case .passwordsValid:
            break
        case .passwordsInvalid:
            isSaveButtonEnabled = false
            saveButtonColour = Constants.SystemColours.lightGreyColour
        case .newPasswordDoesNotMatch:
            alertModel = AlertModel(title: "Error",
                                    message: "New passwords are not the same",
                                    actionTitle: "Cancel")
        case .error:
            alertModel = AlertModel(title: "Error",
                                    message: "An unexpected error occurred",
                                    actionTitle: "Cancel")
        case .success:
            isPasswordChanged = true
            alertModel = AlertModel(title: "Success",
                                    message: "Your password was changed.",
                                    actionTitle: nil)
        }
        let viewModel = ChangePassword.ViewModel(isPasswordChanged: isPasswordChanged,
                                                 alertModel: alertModel,
                                                 isSaveButtonEnabled: isSaveButtonEnabled,
                                                 saveButtonColour: saveButtonColour)
        output.displayPasswordChange(viewModel: viewModel)
    }
}
