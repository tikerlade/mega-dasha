//
//  AppDelegate.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

//import NMAKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        NMAApplicationContext.setAppId("gGf32tYiWmZFkKUgeDEz",
//        appCode: "Ov1N8LD7eqQ04ZQEJHjJCw",
//        licenseKey: "g5WpHWznfMCp0pzu8AA1Jkyob6uAT3p7E1uD6bo6u+K6yvd+krwPGkP0NrBymgHcKXM5NFrgDcedddXmk1kSM/gNiitTkcqAALPR3iLRlh7d5hIdBKQS2x/zTi/LhjPBOlUgNNXFtG60zTOaRusK5GjsEdAA3OSfWrZLxAdkST+E2zc2s/kGzt0vMmwY4FvhkrZN9B7Xj2qgNkwwfnShAdICGnsXFH0Sw9cd84o3x84Y57WXqzstFPUC4fUYcdTdapAtersQVnnC6L+uuvBiSuz0dl3We7Wr6uAHIjrLhoChrybwPcyxvNAxkhtspywGOmd7MZzOINTsfxKTTqGXwp4gRd2wo6w20gFtt8O5LpNW+uA53YBTaZGuAJ9TwUdBcgGpqetpnGplr42IJ2Mx2AiQ/GX1Z7aUSvyojdZuDKmA18rbXQPGYu4qQ+jhxUhYUjp80CwuA72t+eHk1iPBwt0VpFoeAdPw8nfeGyVA/qDa1BJpnM0KCitiLoztPghCJnqhtDZQDdIrokKZSY+hawGZ+fhsZ6yH4oO+af+pI/AtajMvaPTBHdytyk+5ZiVybwGCWdNAP4c/Qg3Yj3L+sRK5mbJnXOIViwVWBfnVNTvpK3bmMvS7CBbeHa8k+l4ksIsX2lX3tUdI/t6Jfcy9k00y+JF1z33kHcmW9NKlgnc=")
        
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


}

