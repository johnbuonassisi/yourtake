//
//  NotificationService.swift
//  YourTake
//
//  Created by John Buonassisi on 2018-01-18.
//  Copyright © 2018 Enovi Inc. All rights reserved.
//

import UserNotifications

protocol NotificationServiceProtocol {
    func registerForPushNotifications()
    func sendPushNotification(username: String,
                              message: String,
                              customPayload: [AnyHashable: Any]?,
                              completion: @escaping BaBoolErrorCompletionBlock)
    func sendPushNotifications(usernames: [String],
                              message: String,
                              customPayload: [AnyHashable: Any]?,
                              completion: @escaping BaBoolErrorCompletionBlock)
}

class NotificationService: NotificationServiceProtocol {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (isGranted, error) in
            print("Result of notification authorization request: \(isGranted)")
            guard isGranted else { return }
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
    }
    
    func sendPushNotification(username: String,
                              message: String,
                              customPayload: [AnyHashable: Any]?,
                              completion: @escaping BaBoolErrorCompletionBlock) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.sendPushNotification(username: username,
                                           message: message,
                                           customPayload: customPayload,
                                           completion: completion)
    }
    
    // Note that the completion block in this method will be executed for each push notification sent
    func sendPushNotifications(usernames: [String],
                              message: String,
                              customPayload: [AnyHashable: Any]?,
                              completion: @escaping BaBoolErrorCompletionBlock) {
        for username in usernames {
            sendPushNotification(username: username,
                                 message: message,
                                 customPayload: customPayload,
                                 completion: completion)
        }
    }
}
