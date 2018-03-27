//
//  AppDelegate.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 26/03/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationBarAppearance = UINavigationBar.appearance()
    var tabBarAppearance  = UITabBar.appearance()
    
    let dataController = DataController(modelName:"Model")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor(red: 242/255.0, green: 120/255.0, blue: 75/255.0,alpha: 1.0)
        navigationBarAppearance.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Palatino-bold", size: 20)!]
        
        tabBarAppearance.tintColor = UIColor.black
        tabBarAppearance.barTintColor = UIColor(red: 245/255.0, green: 160/255.0, blue: 129/255.0,alpha: 0.5)
        
        dataController.load()
        
        guard let tabController = window?.rootViewController as? UITabBarController,
            let navViewController = tabController.viewControllers![0] as? UINavigationController else {
                return true
        }
        
        let ingredientsViewController = navViewController.topViewController as! IngredientsTableViewController
        ingredientsViewController.dataController = dataController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

