//
//  AppDelegate.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Print to verify app startup
        print("AppDelegate: Application did finish launching")
        
        // For iOS 12 and below
        if #available(iOS 13.0, *) {
            // iOS 13+ uses SceneDelegate
            print("AppDelegate: Using SceneDelegate for iOS 13+")
        } else {
            // Create window manually for iOS 12 and below
            print("AppDelegate: Creating window for iOS 12 and below")
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = SplashViewController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("AppDelegate: Configuring scene session")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("AppDelegate: Did discard scene sessions")
    }
}
