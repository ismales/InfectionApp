//
//  AppDelegate.swift
//  InfectionApp
//
//  Created by Сманчос on 04.05.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ParametersViewController())
        window?.makeKeyAndVisible()
        return true
    }
}
