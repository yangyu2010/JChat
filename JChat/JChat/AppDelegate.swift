//
//  AppDelegate.swift
//  JChat
//
//  Created by Young on 2017/4/11.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit
import UserNotifications

private let kApp_key = "1ea152807d53383bc00cafe1"
private let kApp_channel = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        JMessage.setupJMessage(launchOptions,
                               appKey: kApp_key,
                               channel: kApp_channel,
                               apsForProduction: false,
                               category: nil,
                               messageRoaming: false)
        
        JPUSHService.register(forRemoteNotificationTypes:
            UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue,
                              categories: nil)
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                
            })
            UIApplication.shared.registerForRemoteNotifications()
        }else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }

       
        JMSGUser.login(withUsername: "root", password: "123456") { (resultObject, error) in
            
            if (error == nil) {
                print("登录成功")
                print(resultObject ?? "成功了")
            }else {
                print("登录失败")
                print(error ?? "失败了")
            }
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
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

@available(iOS 10.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //let dict = response.notification.request.content.userInfo
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}


// MARK: -自定义打印
func NSLog<Temp>(message : Temp , fileName : String = #file , funcName : String = #function , line : Int = #line)  {
    
    //判断如果在debug模式下才打印
    #if DEBUG
        
        let className = (fileName as NSString).lastPathComponent
        //    print("[\(className)]{\(funcName)}(\(line)):\(message)")
        print("[\(className)]-(\(line))-:\(message)")
        
    #endif
    
}
