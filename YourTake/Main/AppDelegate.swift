//
//  AppDelegate.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        // Check if this is the first time the app was run
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            // Delete existing username and password from the keychain
            do {
                let passwordItems = try KeychainPasswordItem.passwordItems(
                    forService: KeychainConfiguration.serviceName,
                    accessGroup: KeychainConfiguration.accessGroup)
                for item in passwordItems {
                    try item.deleteItem()
                }
            } catch {
                fatalError("Error deleting password items - \(error)")
            }
            
            // Update the flag in the user default database
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize()
        }
      
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create main navigation controller
        let navigationVc = SwipelessNavigationController(); // Will not pop a view controller when a left swipe gesture occurs
                                                            // This is particularly important for the login and draw vcs
        // Create challenge view controller
        let cleanStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let challengeVc = cleanStoryBoard.instantiateViewController(withIdentifier: "ChallengeList")
        
        // Try to get an existing username and password from the keychain
        var passwordItems: [KeychainPasswordItem]
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName,
                                                                   accessGroup: KeychainConfiguration.accessGroup)
        } catch {
            fatalError("Error fetching password items - \(error)")
        }
        
        // If a username and password have been previously saved, attempt login
        if passwordItems.count > 0 {
            do {
                let backendClient = Backend.sharedInstance.getClient()
                backendClient.login(username: passwordItems[0].account,
                                    password: try passwordItems[0].readPassword(),
                                    completion: { (success) -> Void in
                                        if success {
                                            // When login success, push challenge vc
                                            self.window?.rootViewController = challengeVc
                                            let notificationService: NotificationServiceProtocol = NotificationService()
                                            notificationService.registerForPushNotifications()
                                        } else {
                                            // When login fails, push challenge then login vcs
                                            let signUpVc = cleanStoryBoard.instantiateViewController(withIdentifier: "Signup")
                                            navigationVc.pushViewController(signUpVc, animated: false)
                                        }
                })
            } catch {
                fatalError("Error reading password from keychain - \(error)")
            }
        } else {
            // If existing username/password do not exist, show signup vc
            let signUpVc = cleanStoryBoard.instantiateViewController(withIdentifier: "Signup")
            navigationVc.pushViewController(signUpVc, animated: false)
        }
        
        // Always show the navigation controller, challenge controller will be pushed after login
        window?.rootViewController = navigationVc
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        print("Registered for Remote Notifications, Device Token: \(token)")
        
        let backendClient = Backend.sharedInstance.getClient()
        backendClient.enablePushNotificationsForCurrentUser(token: deviceToken) { (isSuccess, error) in
            guard isSuccess else {
                print("Failed to enable push notification for user \(backendClient.getCurrentUserName()) \(String(describing: error?.localizedDescription))")
                return
            }
            print("Successfully enabled push notifications for user \(backendClient.getCurrentUserName())")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for Remote Notifications")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

