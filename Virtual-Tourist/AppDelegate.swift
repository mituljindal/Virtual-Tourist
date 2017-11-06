//
//  AppDelegate.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 24/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let stack = CoreDataStack(modelName: "Model")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        stack.autoSave(1)
        return true
    }
}

