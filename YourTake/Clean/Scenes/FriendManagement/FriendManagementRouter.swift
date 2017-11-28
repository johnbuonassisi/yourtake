//
//  FriendManagementRouter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-11-28.
//  Copyright (c) 2017 Enovi Inc.. All rights reserved.
//
//  This file was generated by the Clean Swift HELM Xcode Templates
//  https://github.com/HelmMobile/clean-swift-templates

import UIKit

protocol FriendManagementRouterInput {
    
}

protocol FriendManagementRouterDataSource: class {
    
}

protocol FriendManagementRouterDataDestination: class {
    
}

class FriendManagementRouter: FriendManagementRouterInput {
    
    weak var viewController: FriendManagementViewController!
    weak private var dataSource: FriendManagementRouterDataSource!
    weak var dataDestination: FriendManagementRouterDataDestination!
    
    init(viewController: FriendManagementViewController, dataSource: FriendManagementRouterDataSource, dataDestination: FriendManagementRouterDataDestination) {
        self.viewController = viewController
        self.dataSource = dataSource
        self.dataDestination = dataDestination
    }
    
    // MARK: Navigation
    
    // MARK: Communication
    
    func passDataToNextScene(for segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        
    }
}
