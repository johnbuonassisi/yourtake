//
//  Notifier.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-06.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

public protocol Notifier {
    associatedtype Notification: RawRepresentable
}

public extension Notifier where Notification.RawValue == String {
    
    // MARK: - Static Computed Variables
    
    private static func nameFor(notification: Notification) -> NSNotification.Name {
        return NSNotification.Name(rawValue: "\(self).\(notification.rawValue)")
    }
    
    // MARK: - Static Function
    
    // Post
    
    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        let name = nameFor(notification: notification)
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    // Add
    
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
        let name = nameFor(notification: notification)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    // Remove
    
    static func removeObserver(observer: AnyObject, notification: Notification, object: AnyObject? = nil) {
        let name = nameFor(notification: notification)
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
}

class ChallengeCreationNotifier: Notifier {
    enum Notification: String {
        case creatingChallenge
        case successfullyCreatedChallenge
        case failedToCreateChallenge
    }
}

class TakeCreationNotifier: Notifier {
    enum Notification: String {
        case creatingTake
        case successfullyCreatedTake
        case failedToCreateTake
    }
}
