//
//  Backend.swift
//  YourTake
//
//  Created by Olivier Thomas on 2017-01-09.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import Foundation
import SystemConfiguration

final class Backend {
    static let sharedInstance = Backend()
    private init() {}
    
    //private let localClient : BaClient = LocalClient()
    private let baasBoxClient : BaClient = BaasBoxClient()
    
    func getClient() -> BaClient {
        /*if isNetworkAvailable() {
            return Backend.sharedInstance.baasBoxClient
        } else {
            return Backend.sharedInstance.localClient
        }*/
        return Backend.sharedInstance.baasBoxClient
    }

    private func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
