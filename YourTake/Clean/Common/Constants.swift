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

struct Constants {
    
    struct SystemColours {
        static let blueColour = UIColor(red: 0.0,
                                        green: 122.0/255.0,
                                        blue: 255.0/255.0,
                                        alpha: 1.0)
        
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
    }
}
