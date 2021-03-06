//
//  AppDelegate.swift
//  Multisig
//
//  Created by Dmitry Bespalov. on 14.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        App.shared.firebaseConfig.setUp()
        App.shared.theme.setUp()

        #if DEBUG
        Tracker.shared.append(handler: ConsoleTracker())
        #endif
        Tracker.shared.append(handler: FirebaseTrackingHandler())

        // The requirement is to set num_safes property to "0" when there are no Safes
        #warning("TODO: refactor this is everywhere around the app")
        Tracker.shared.setUserProperty("\(Safe.count)", for: TrackingUserProperty.numSafes)
        Tracker.shared.setUserProperty("\(SafeTransactionSigner.numberOfKeysImported())", for: TrackingUserProperty.numKeysImported)

        App.shared.notificationHandler.setUpMessaging(delegate: self)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogService.shared.error("Failed to registed to remote notifications \(error)")
    }
}
