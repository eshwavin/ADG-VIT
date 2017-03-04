//
//  AppDelegate.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 25/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import RealmSwift
import UserNotifications

var reachability: Reachability?
var reachabilityStatus = ""
let realm = try! Realm()
var ThreeD = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var internetCheck: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        // Reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        self.internetCheck = Reachability.forInternetConnection()
        self.internetCheck?.startNotifier()
        self.statusChangedWithReachability(currentReachabilityStatus: self.internetCheck!)
        
        // Push Notifications
        
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
//        let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted {
                application.registerForRemoteNotifications()
            }
            else {
                print("Remote Notification Permission Denied")
            }
            
        }
        
        
        
        return true
    }
    
    // MARK: - Reachability
    
    func reachabilityChanged(_ notification: Notification) {
        reachability = notification.object as? Reachability
        statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }
    
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        
        let networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        
        switch networkStatus.rawValue {
        case NotReachable.rawValue: reachabilityStatus = NOACCESS
        case ReachableViaWiFi.rawValue: reachabilityStatus = WIFI
        case ReachableViaWWAN.rawValue: reachabilityStatus = WWAN
        default: return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
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
            
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        
        // remove realm weather objects
        try! realm.write {
            realm.delete(realm.objects(Weather.self))
        }
    }
    
    // MARK: - Quick Actions
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.vinnu.ADG-VIT.goToTwoCredits" {
            
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "TwoCreditNav")

            ThreeD = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            
            self.window?.rootViewController = sw
            
            let destinationController = storyboard.instantiateViewController(withIdentifier: "TwoCreditMain") as! TwoCreditCourseViewController
            
            let navigationController = UINavigationController(rootViewController: destinationController)
            
            sw.pushFrontViewController(navigationController, animated: true)
            
            

            
        }
        
    }

    // MARK: - Push Notifications
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound])
    }
    
    

}

