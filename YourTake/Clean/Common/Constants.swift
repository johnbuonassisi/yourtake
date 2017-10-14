//
//  Constants.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

struct Constants {
    static let systemBlueColour = UIColor(red: 0.0,
                                             green: 122.0/255.0,
                                             blue: 255.0/255.0,
                                             alpha: 1.0)
    
    static let systemLightGreyColour = UIColor(red: 180.0/255.0,
                                                   green: 180.0/255.0,
                                                   blue: 180.0/255.0,
                                                   alpha: 1.0)
    struct SegueIdentifiers {
        struct PasswordVerificationScene {
            static let changePasswordSegue = "ChangePasswordSegue"
            static let resetPasswordSegue = "ResetPasswordSegue"
        }
    }
}
