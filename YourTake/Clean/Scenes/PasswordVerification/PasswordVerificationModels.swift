//
//  PasswordVerificationModels.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-08.
//  Copyright (c) 2017 Enovi Inc. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct PasswordVerification {
    
    struct VerifyPassword {
        
        struct Request {
            var password: String
        }
        
        struct Response {
            var isPasswordVerified: Bool
            var error: PasswordVerificationError?
            
            enum PasswordVerificationError: Error {
                case invalidPasswordProvided
                case noStoredPasswordFound
                case passwordMismatch
                case errorRetrievingPassword
            }
        }
        
        struct ViewModel {
            var isPasswordVerified: Bool
            var alertModel: AlertModel?
            var isContinueButtonEnabled: Bool
            var continueButtonColour: UIColor
        }
    }
}
