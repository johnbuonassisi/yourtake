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
    func sendPushNotificationsForNewChallenge(recipients: [String],
                                              secondsRemainingInChallenge: Int,
                                              completion: @escaping BaBoolErrorCompletionBlock)
    func sendPushNotificationForFriendRequest(friend: String, completion: @escaping BaBoolErrorCompletionBlock)
    func sendPushNotificationForFriendRequestAcceptance(friend: String, completion: @escaping BaBoolErrorCompletionBlock)
    func getNotificationType(from dictionary: [String: AnyObject]) -> NotificationType?
}

class NotificationService: NotificationServiceProtocol {
    
    func sendPushNotificationsForNewChallenge(recipients: [String],
                                              secondsRemainingInChallenge: Int,
                                              completion: @escaping BaBoolErrorCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let backendClient = Backend.sharedInstance.getClient()
            let roundedTimeRemaining = TimeService.getRoundedTimeRemaining(numSecondsRemaining: secondsRemainingInChallenge)
            let message = "\(backendClient.getCurrentUserName()) has sent you a new challenge!" +
                " Hurry you only have \(roundedTimeRemaining) to respond."
            let customPayload = [NotificationPayload.notificationTypeKey: NotificationType.newChallenge.rawValue]
            self.sendPushNotifications(usernames: recipients,
                                  message: message,
                                  customPayload: customPayload,
                                  completion: completion)
        }
    }
    
    func sendPushNotificationForFriendRequest(friend: String, completion: @escaping BaBoolErrorCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let backendClient = Backend.sharedInstance.getClient()
            let message = "\(backendClient.getCurrentUserName()) sent you a friend request."
            let customPayload = [NotificationPayload.notificationTypeKey: NotificationType.friendRequest.rawValue]
            self.sendPushNotification(username: friend,
                                 message: message,
                                 customPayload: customPayload,
                                 completion: completion)
        }
    }
    
    func sendPushNotificationForFriendRequestAcceptance(friend: String, completion: @escaping BaBoolErrorCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let backendClient = Backend.sharedInstance.getClient()
            let message = "You and \(backendClient.getCurrentUserName()) are now friends. Send \(backendClient.getCurrentUserName()) a challenge!"
            let customPayload = [NotificationPayload.notificationTypeKey: NotificationType.friendRequestAcceptance.rawValue]
            self.sendPushNotification(username: friend,
                                 message: message,
                                 customPayload: customPayload,
                                 completion: completion)
        }
    }
    
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
    
    func getNotificationType(from dictionary: [String: AnyObject]) -> NotificationType? {
        var notificationType: NotificationType?
        if let customPayload = dictionary[NotificationPayload.customPayloadKey] as? [String: String] {
            if let notificationTypeString = customPayload[NotificationPayload.notificationTypeKey] {
                notificationType = NotificationType(rawValue: notificationTypeString)
            }
        }
        return notificationType
    }
    
    private func sendPushNotification(username: String,
                              message: String,
                              customPayload: [String: String]?,
                              completion: @escaping BaBoolErrorCompletionBlock) {
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.sendPushNotification(username: username,
                                           message: message,
                                           customPayload: customPayload,
                                           completion: completion)
    }
    
    // Note that the completion block in this method will be executed for each push notification sent
    private func sendPushNotifications(usernames: [String],
                              message: String,
                              customPayload: [String: String]?,
                              completion: @escaping BaBoolErrorCompletionBlock) {
        for username in usernames {
            sendPushNotification(username: username,
                                 message: message,
                                 customPayload: customPayload,
                                 completion: completion)
        }
    }
}
