//
//  AppDelegate.swift
//  ios-sample-listing
//
//  Created by Meng on 03/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = UINavigationController(rootViewController: RecipeListing())
		self.window?.makeKeyAndVisible()
		
		return true
	}

}
