//
//  AppDelegate.swift
//  RealmDemo
//
//  Created by qwer on 2018/3/13.
//  Copyright © 2018年 qwer. All rights reserved.
//
import RealmSwift.Swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    我将这个实例命名为 uiRealm，就是因为它应该只在 UI 线程中被使用。
    static let uiRealm:Realm? = try! Realm()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        let vx = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.rootViewController = vx
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

