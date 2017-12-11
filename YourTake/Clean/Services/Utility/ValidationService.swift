//
//  ValidationService.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class ValidationService: NSObject {
    
    private static let MINIMUM_PASSWORD_SIZE = 7
    private static let MINIMUM_USERNAME_SIZE = 5
    
    static func isValidEmailAddress(_ emailAddress: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
    static func isValidUserName(_ username: String) -> Bool {
        let userNameRegEx = "[A-Z0-9a-z._]*"
        let userNameTest = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
        return username.count >= MINIMUM_USERNAME_SIZE && userNameTest.evaluate(with: username)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= MINIMUM_PASSWORD_SIZE
    }

}
