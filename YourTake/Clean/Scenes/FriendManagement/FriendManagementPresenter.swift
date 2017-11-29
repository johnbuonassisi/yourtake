//
//  FriendManagementPresenter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-28.
//  Copyright (c) 2017 Enovi Inc.. All rights reserved.
//
//  This file was generated by the Clean Swift HELM Xcode Templates
//  https://github.com/HelmMobile/clean-swift-templates

protocol FriendManagementPresenterInput {
    func presentFriends(response: FriendManagementScene.FetchFriends.Response)
}

protocol FriendManagementPresenterOutput: class {
    func displayFriends(response: FriendManagementScene.FetchFriends.ViewModel)
}

class FriendManagementPresenter: FriendManagementPresenterInput {
    
    weak var output: FriendManagementPresenterOutput?
    
    private let requestTypeToTitleDictionary:
        [FriendManagementScene.FetchFriends.ViewModel.FriendRequestType: String] =
        [.accept: "accept", .accepted: "accepted", .accepting: "accepting",
         .request: "request", .requested: "requested", .requesting: "requesting"]
    private let defaultFriendsAndAcquiantancesHeaderTitle = "Friend Requests"
    private let defaultOtherUsersHeaderTitle = "People You May Know"
    
    // MARK: Presentation logic
    func presentFriends(response: FriendManagementScene.FetchFriends.Response) {
        
        var friendsAndAcquiantances = [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]()
        createViewModelsForAcceptSet(acceptSet: response.acceptSet,
                                     acceptingSet: response.acceptingSet,
                                     viewModelList: &friendsAndAcquiantances)
        
        
        createViewModelsForAcceptedSet(acceptedSet: response.acceptedSet,
                                       viewModelList: &friendsAndAcquiantances)
        
        createViewModelsForRequestedSet(requestedSet: response.requestedSet,
                                        viewModelList: &friendsAndAcquiantances)
        
        var otherUsers = [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]()
        createViewModelsForRequestSet(requestSet: response.requestSet,
                                      requestingSet: response.requestingSet,
                                      viewModelList: &otherUsers)
        
        let otherUsersHeaderTitle = otherUsers.count == 0 ? nil : defaultOtherUsersHeaderTitle
        let viewModel = FriendManagementScene.FetchFriends
            .ViewModel(friendsAndAcquaintances: friendsAndAcquiantances,
                       otherUsers: otherUsers,
                       freindsAndAcquaintancesHeaderTitle: defaultFriendsAndAcquiantancesHeaderTitle,
                       otherUsersHeaderTitle: otherUsersHeaderTitle)
        output?.displayFriends(response: viewModel)
    }
    
    private func createViewModelsForAcceptSet(
        acceptSet: Set<String>,
        acceptingSet: Set<String>,
        viewModelList: inout [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]) {
        for userName in acceptSet.sorted() {
            var user: FriendManagementScene.FetchFriends.ViewModel.UserViewModel
            if acceptingSet.contains(userName) {
                user = FriendManagementScene.FetchFriends
                    .ViewModel.UserViewModel(userName: userName,
                                             buttonTitle: requestTypeToTitleDictionary[.accepting]!,
                                             isButtonEnabled: false,
                                             buttonColour: Constants.SystemColours.lightGreyColour,
                                             friendRequestType: .accepting)
            } else {
                user = FriendManagementScene.FetchFriends
                    .ViewModel.UserViewModel(userName: userName,
                                             buttonTitle: requestTypeToTitleDictionary[.accept]!,
                                             isButtonEnabled: true,
                                             buttonColour: Constants.SystemColours.blueColour,
                                             friendRequestType: .accept)
            }
            viewModelList.append(user)
        }
    }
    
    private func createViewModelsForAcceptedSet(
        acceptedSet: Set<String>,
        viewModelList: inout [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]) {
        
        for userName in acceptedSet.sorted() {
            let user = FriendManagementScene.FetchFriends
                .ViewModel.UserViewModel(userName: userName,
                                         buttonTitle: requestTypeToTitleDictionary[.accepted]!,
                                         isButtonEnabled: false,
                                         buttonColour: UIColor.green,
                                         friendRequestType: .accepted)
            viewModelList.append(user)
        }
    }
    
    private func createViewModelsForRequestedSet(
        requestedSet: Set<String>,
        viewModelList: inout [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]) {
        
        for userName in requestedSet.sorted() {
            let user = FriendManagementScene.FetchFriends
                .ViewModel.UserViewModel(userName: userName,
                                         buttonTitle: requestTypeToTitleDictionary[.requested]!,
                                         isButtonEnabled: false,
                                         buttonColour: Constants.SystemColours.lightGreyColour,
                                         friendRequestType: .requested)
            viewModelList.append(user)
        }
    }
    
    private func createViewModelsForRequestSet(
        requestSet: Set<String>,
        requestingSet: Set<String>,
        viewModelList: inout [FriendManagementScene.FetchFriends.ViewModel.UserViewModel]) {
            for userName in requestSet.sorted() {
                
                var user: FriendManagementScene.FetchFriends.ViewModel.UserViewModel
                if requestingSet.contains(userName) {
                    user = FriendManagementScene.FetchFriends
                        .ViewModel.UserViewModel(userName: userName,
                                                 buttonTitle: requestTypeToTitleDictionary[.requesting]!,
                                                 isButtonEnabled: false,
                                                 buttonColour: Constants.SystemColours.lightGreyColour,
                                                 friendRequestType: .request)
                } else {
                    user = FriendManagementScene.FetchFriends
                        .ViewModel.UserViewModel(userName: userName,
                                                 buttonTitle: requestTypeToTitleDictionary[.request]!,
                                                 isButtonEnabled: true,
                                                 buttonColour: Constants.SystemColours.blueColour,
                                                 friendRequestType: .request)
                }
                viewModelList.append(user)
            }
    }
    
}
