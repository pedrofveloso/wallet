//
//  AppDelegate.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {
    func initializeWallet() {
        
    }
}
