//
//  AppDelegate.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().kotra_songeulssi_13], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().kotra_songeulssi_13], for: .highlighted)
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().kotra_songeulssi_13], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont().kotra_songeulssi_13], for: .highlighted)

        FirebaseApp.configure()
        
        //custom font 있는지 없는지 if로 확인해서 실행함
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        Thread.sleep(forTimeInterval: 2.0) // 런치스크린 표시 시간 1초 강제 지연

        
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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           
           // 세로방향 고정
           return UIInterfaceOrientationMask.portrait
       }


}

