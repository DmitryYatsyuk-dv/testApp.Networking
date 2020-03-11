//
//  AppDelegate.swift
//  Networking
//
//  Created by Lucky on 06/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var bgSessionCompetionHandler: (() -> ())?
    
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        
        bgSessionCompetionHandler = completionHandler
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
       let appId = Settings.appID
       
    if url.scheme != nil && url.scheme!.hasPrefix("fb: \(String(describing: appId))") && url.host ==  "authorize" {
           return ApplicationDelegate.shared.application(app, open: url, options: options)
       }
       
       return false
   }
   
    func application(open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     
        let handled: Bool = ApplicationDelegate.shared.application(UIApplication.init(), open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
     
        return handled
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


}

