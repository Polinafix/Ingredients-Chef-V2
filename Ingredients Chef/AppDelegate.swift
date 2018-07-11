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
        navigationBarAppearance.tintColor = UIColor.black
        navigationBarAppearance.barTintColor = UIColor(red: 229/255.0, green: 238/255.0, blue: 252/255.0,alpha: 0.4)
        //(242, 114, 2
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black, NSAttributedStringKey.font:UIFont(name: "Palatino-bold", size: 20)!]
        tabBarAppearance.tintColor = UIColor(red: 249/255.0, green: 123/255.0, blue: 12/255.0,alpha: 1.0)
        tabBarAppearance.barTintColor = UIColor(red: 229/255.0, green: 238/255.0, blue: 252/255.0,alpha: 0.1)
        
        dataController.load()
        
        guard let tabController = window?.rootViewController as? UITabBarController,
            let navViewControllerOne = tabController.viewControllers![0] as? UINavigationController, let navViewControllerTwo = tabController.viewControllers![1] as? UINavigationController  else {
                return true
        }

        let ingredientsViewController = navViewControllerOne.topViewController as! IngredientsTableViewController
        let favsViewController = navViewControllerTwo.topViewController as! FavoritesTableViewController
        ingredientsViewController.dataController = dataController
        favsViewController.dataController = dataController
        return true
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }


}

