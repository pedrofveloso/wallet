//
//  AppDelegate.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeWallet()
    }
}

private extension AppDelegate {
    func initializeWallet() -> Bool{
        let root = UIViewController()
        
        // For test purposes
        let view = FinanceInfoCardView()
        root.view.addSubview(view)
        
        view
            .top(to: root.view.safeAreaLayoutGuide.topAnchor)
            .horizontals(to: root.view)
        // End test
        
        window?.rootViewController = root
        window?.makeKeyAndVisible()

        return true
    }
}
