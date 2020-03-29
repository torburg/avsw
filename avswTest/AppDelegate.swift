//
//  AppDelegate.swift
//  avswTest
//
//  Created by Maksim Torburg on 26.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Storage.instance.doesExist())
        if Storage.instance.doesExist() {
            Storage.instance.load()
        } else {
            Storage.instance.generatePlist()
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        let rootViewController = AuthorizationViewController()
        let rootViewController = TabBarViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
