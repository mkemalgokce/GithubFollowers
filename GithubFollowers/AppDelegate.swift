//
//  AppDelegate.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureTabBar()
        configureNavigationBar()
        
        return true
    }
    
    func configureTabBar() {
        UITabBar.appearance().tintColor = .systemGreen
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }
}

