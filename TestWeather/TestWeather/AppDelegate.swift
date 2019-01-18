//
//  AppDelegate.swift
//  TestWeather
//
//  Created by user on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    
    //MARK - Splash screen, checking if app has opened for first time
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnboardingFinish), name: NotificationNames.unboardingFinish.notification, object: nil)
        let SplashViewController: SplashViewController = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        let CitiesNavigationController: CitiesNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "CitiesNavigationController") as! CitiesNavigationController
        
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            self.window?.rootViewController = CitiesNavigationController
            self.window?.makeKeyAndVisible()
            print("App was launched earlier")
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            self.window?.rootViewController = SplashViewController
            self.window?.makeKeyAndVisible()
            print("App launched first time")
        }
        
        registerForPushNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    
        return true
    }
    
    @objc func handleUnboardingFinish() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let CitiesNavigationController: CitiesNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "CitiesNavigationController") as! CitiesNavigationController
        self.window?.rootViewController = CitiesNavigationController
        self.window?.makeKeyAndVisible()
        
    }
    
    //MARK - Register for local/push/remote notifications
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //MARK - Firebase messaging delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    
    //MARK - Get device token
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("dasfasd")

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    //MARK - Schedule Notification
    
    static func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New City Discovered"
        content.body = "You have discovered a new city. Check this feature right now!"
        content.sound = UNNotificationSound.default
        content.badge = 0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let identifier = "UNLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        print("request")
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
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

