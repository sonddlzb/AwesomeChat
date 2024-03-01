//
//  AppDelegate.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow()
        configRoot()
        self.window?.makeKeyAndVisible()
        return true
    }

    func configRoot() {
        let applicationNavigator = ApplicationNavigator()
        let signInViewController = applicationNavigator.makeViewController()
        let rootViewController = UINavigationController(rootViewController: signInViewController)
        rootViewController.navigationBar.isHidden = true
        self.window?.rootViewController = rootViewController
    }
}
