//
//  RahalAppApp.swift
//  RahalApp
//
//  Created by Juman Dhaher on 19/10/1445 AH.
//

import SwiftUI
import OneSignalFramework



@main
struct RahalAppApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true

    var body: some Scene {
        WindowGroup {
            SplashView(isOnboarding: $isOnboarding)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // Remove this method to stop OneSignal Debugging
       OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
       // OneSignal initialization
       OneSignal.initialize("a1f9489d-25d3-4e5f-8f62-7bcc0ef497f4", withLaunchOptions: launchOptions)

       // requestPermission will show the native iOS notification permission prompt.
       // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
       OneSignal.Notifications.requestPermission({ accepted in
         print("User accepted notifications: \(accepted)")
       }, fallbackToSettings: true)

       // Login your customer with externalId
        OneSignal.login("EXTERNAL_ID")

            
       return true
    }
}
