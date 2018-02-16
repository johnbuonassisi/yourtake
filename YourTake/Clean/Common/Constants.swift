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
typealias DisplayTakeCellIdentifiers = Constants.CellIdentifiers.DisplayTakeScene
typealias NotificationType = Constants.PushNotifications.CustomPayload.NotificationType
typealias NotificationPayload = Constants.PushNotifications.CustomPayload
typealias SegueIdentifiers = Constants.SegueIdentifiers

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
    
    struct StoryboardIdentifiers {
        static let MainStoryboard = "Main"
        static let RootViewController = "RootViewController"
        static let SignupViewController = "SignupViewController"
    }
    
    struct SegueIdentifiers {
        struct PasswordVerificationScene {
            static let changePasswordSegue = "ChangePasswordSegue"
            static let resetPasswordSegue = "ResetPasswordSegue"
        }
        struct ListChallengesScene {
            struct UserListChallengesScene {
                static let friendManagementSegue = "UserChallengeListFriendManagementSegue"
                static let photoPreviewSegue = "UserChallengeListPhotoPreviewSegue"
                static let settingsSegue = "UserChallengeListSettingsSegue"
                static let listTakesSegue = "UserChallengeListTakesSegue"
            }
            struct FriendListChallengeScene {
                static let friendManagementSegue = "FriendChallengeListFriendManagementSegue"
                static let photoPreviewSegue = "FriendChallengeListPhotoPreviewSegue"
                static let settingsSegue = "FriendChallengeListSettingsSegue"
                static let listTakesSegue = "FriendChallengeListTakesSegue"
            }
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
        struct DisplayTakeScene {
            static let votersCellId = "VotersTableViewCell"
        }
    }
    
    struct Dimensions {
        static let navigationBarHeight: CGFloat = 44.0
        static let toolBarHeight: CGFloat = 44.0
    }
    
    struct PushNotifications {
        struct CustomPayload {
            static let customPayloadKey = "custom"
            static let notificationTypeKey = "notificationType"
            
            enum NotificationType: String {
                case newChallenge = "newChallenge"
                case friendRequest = "friendRequest"
                case friendRequestAcceptance = "friendRequestAcceptance"
            }
        }
    }
}
