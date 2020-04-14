//
//  AppDelegate.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 07/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = Colors.marvelRed
        
        return true
    }


}

