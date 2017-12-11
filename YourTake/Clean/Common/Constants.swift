//
//  Constants.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

typealias PasswordVerificationSceneSegueIds = Constants.SegueIdentifiers.PasswordVerificationScene
typealias ListChallengeSceneCellIdentifiers = Constants.CellIdentifiers.ListChallengesScene
typealias ListTakesSceneCellIdentifiers = Constants.CellIdentifiers.ListTakesScene
typealias FriendManagementCellIdentifiers = Constants.CellIdentifiers.FriendManagementScene

struct Constants {
    
    struct SystemColours {
        
        // Hex Equivalent: 0x007AFF
        static let blueColour = UIColor(red: 0.0,
                                        green: 122.0/255.0,
                                        blue: 255.0/255.0,
                                        alpha: 1.0)
        
        // Hex Equivalent: 0xB4B4B4
        static let lightGreyColour = UIColor(red: 180.0/255.0,
                                             green: 180.0/255.0,
                                             blue: 180.0/255.0,
                                             alpha: 1.0)
    }
    
    struct SegueIdentifiers {
        struct PasswordVerificationScene {
            static let changePasswordSegue = "ChangePasswordSegue"
            static let resetPasswordSegue = "ResetPasswordSegue"
        }
        struct ListChallengesScene {
            static let photoPreviewSegue = "PhotoPreviewSegue"
            static let friendManagementSegue = "FriendManagementSegue"
            static let settingsSegue = "SettingsSegue"
        }
    }
    
    struct CellIdentifiers {
        struct ListChallengesScene {
            static let userChallengeCellId = "UserChallengeTableViewCell"
            static let friendChallengeCellId = "FriendChallengeTableViewCell"
            static let noChallengeCellId = "EmptyChallengeTableViewCell"
            static let noFriendsCellId = "NoFriendsCell"
        }
        struct ListTakesScene {
            static let takeCellId = "TakeCollectionViewCell"
        }
        struct FriendManagementScene {
            static let friendManagementCellId = "FriendManagementTableViewCell"
        }
    }
    
    struct Dimensions {
        static let navigationBarHeight: CGFloat = 44.0
        static let toolBarHeight: CGFloat = 44.0
    }
}
