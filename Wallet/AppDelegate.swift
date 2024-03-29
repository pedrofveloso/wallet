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
        let statementPresenter = StatementPresenter(datasource: Datasource.shared)
        window?.rootViewController = StatementViewController(presenter: statementPresenter)
        window?.makeKeyAndVisible()

        return true
    }
}
