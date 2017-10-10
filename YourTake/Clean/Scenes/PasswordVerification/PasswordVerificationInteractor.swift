//
//  PasswordVerificationInteractor.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-08.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PasswordVerificationInteractorInput {
    func verifyPassword(request: PasswordVerification.VerifyPassword.Request)
    func validatePassword(request: PasswordVerification.VerifyPassword.Request)
}

protocol PasswordVerificationInteractorOutput {
    func presentSomething(response: PasswordVerification.VerifyPassword.Response)
}

class PasswordVerificationInteractor: PasswordVerificationInteractorInput {

    var output: PasswordVerificationInteractorOutput!

    // MARK: - Business logic
    
    func validatePassword(request: PasswordVerification.VerifyPassword.Request) {
        
        var responseError: PasswordVerification.VerifyPassword.Response.PasswordVerificationError?
        if !ValidationService.isValidPassword(request.password) {
            responseError = .invalidPasswordProvided
        }
        sendResponse(isPasswordVerified: false, responseError: responseError)
    }

    func verifyPassword(request: PasswordVerification.VerifyPassword.Request) {
        
        var responseError: PasswordVerification.VerifyPassword.Response.PasswordVerificationError?
        var isPasswordVerified = false
        if !ValidationService.isValidPassword(request.password) {
            responseError = .invalidPasswordProvided
            sendResponse(isPasswordVerified: isPasswordVerified, responseError: responseError)
            return
        }
        
        var passwordItems: [KeychainPasswordItem]
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName,
                                                                   accessGroup: KeychainConfiguration.accessGroup)
            if passwordItems.count < 1 {
                responseError = .noStoredPasswordFound
                sendResponse(isPasswordVerified: isPasswordVerified, responseError: responseError)
                return
            }
            let storedPassword = try passwordItems[0].readPassword()
            if storedPassword == request.password {
                isPasswordVerified = true
            } else {
                responseError = .passwordMismatch
            }
        } catch (let error as KeychainPasswordItem.KeychainError) {
            responseError = .errorRetrievingPassword
            print("Error fetching password items - \(error)")
        } catch {
            responseError = .errorRetrievingPassword
            print("Unexpected error - \(error)")
        }
        
        // NOTE: Pass the result to the Presenter
        sendResponse(isPasswordVerified: isPasswordVerified, responseError: responseError)
    }
    
    func sendResponse(isPasswordVerified: Bool,
                      responseError: PasswordVerification.VerifyPassword.Response.PasswordVerificationError?) {
        
        let response = PasswordVerification.VerifyPassword.Response(isPasswordVerified: isPasswordVerified,
                                                                    error: responseError)
        output.presentSomething(response: response)
    }
}
