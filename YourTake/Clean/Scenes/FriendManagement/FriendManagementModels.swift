//
//  FriendManagementModels.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-28.
//  Copyright (c) 2017 Enovi Inc.. All rights reserved.
//
//  This file was generated by the Clean Swift HELM Xcode Templates
//  https://github.com/HelmMobile/clean-swift-templates
//
//  Type "usecase" for some magic!

struct FriendManagementScene {
    
    struct UpdateNeworkStatus {
        struct Request {
            var isEnabled: Bool
        }
    }
    
    struct AcceptFriendRequest {
        struct Request {
            var userName: String
        }
    }
    
    struct SendFriendRequest {
        struct Request {
            var userName: String
        }
    }
    
    struct FetchFriends {
        
        struct Request {
            var requestType: RequestType
            
            enum RequestType {
                case fetchAll
                case fetchUpdate
            }
        }
        
        struct Response {
            var acceptedSet: Set<String>
            var acceptSet: Set<String>
            var acceptingSet: Set<String>
            var requestedSet: Set<String>
            var requestSet: Set<String>
            var requestingSet: Set<String>
        }
        
        struct ViewModel {
            var friendsAndAcquaintances: [UserViewModel]
            var otherUsers: [UserViewModel]
            var friendsAndAcquaintancesHeaderTitle: String?
            var otherUsersHeaderTitle: String?
            
            struct UserViewModel {
                var userName: String
                var buttonTitle: String
                var isButtonEnabled: Bool
                var buttonColour: UIColor
                var friendRequestType: FriendRequestType
            }
            
            enum FriendRequestType {
                case accepted
                case accept
                case accepting
                case requested
                case request
                case requesting
            }
        }
    }
    
}