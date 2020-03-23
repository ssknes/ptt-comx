//
//  AppDelegate.swift
//  topcpai
//
//  Created by NB590194 on 11/30/16.
//  Copyright © 2016 PTT ICT Solutions. All rights reserved.
//

import UIKit
import XCGLogger
import SwiftKeychainWrapper
import Firebase
import UserNotifications
import Fabric
import Crashlytics
import FirebaseMessaging
import FirebaseInstanceID

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var startTimer: NSDate?
    var stopTimer: NSDate?
    var userInfo: [AnyHashable : Any]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        
        if (launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary) != nil{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signin = storyBoard.instantiateViewController(withIdentifier: "main") as! SignInViewController
            signin.openFromNoti = true
            //signin.userInfo = GlobalVar userInfo!
            self.window?.rootViewController = signin
        }
        
        // Setup logging tools
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        
        // Start Firebase
        // Register for remote notifications
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)),
                                               name:  NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        // clear badge
        application.applicationIconBadgeNumber = 0
        // end Firebase
        
        // Make status bar white
        UINavigationBar.appearance().barStyle = .black
        
        // hide status bar, combined with info.plist
        // application.statusBarHidden = true
        
        // clear old keychain user information
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(Bundle.main.releaseVersionNumber, forKey: "appVersion")
        userDefaults.setValue(Bundle.main.buildVersionNumber, forKey: "versionCode")
        let domain = GlobalVar.sharedInstance.appMode.getUrl()
        userDefaults.setValue(domain, forKey: "serviceURL")
        
        //userDefaults.set("SomeStringValueYouWantToSave", forKey: "test")
        
        
        userDefaults.synchronize()
        
        //change status bar style
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 15.0/255.0, green: 11.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if !(window?.rootViewController is SignInViewController){
            startTimer = NSDate()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //self.reloadBadge()
        //Messaging.messaging().disconnect()
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if startTimer != nil{
            stopTimer = NSDate()
            if let isSessionExpire = isSessionExpire(startTimer!, stopTimer!) as Bool?{
                if isSessionExpire {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let signin = storyBoard.instantiateViewController(withIdentifier: "main") as! SignInViewController
                    self.window?.rootViewController = signin
                }
            }
        }
        if GlobalVar.sharedInstance.mockNotification {
            MockOpenFromNoti()
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FCMUtilities.connectToFcm()
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.reloadBadge()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.userInfo = userInfo
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(userInfo, forKey: "userInfo")
        userDefaults.set("SomeStringValueYouWantToSave", forKey: "test1")
        
        userDefaults.synchronize()
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        GlobalVar.sharedInstance.userInfo = userInfo
        
        if application.applicationState == .active {
            FCMUtilities.receiveNotificationFromForeground(userInfo: userInfo as [NSObject : AnyObject])
            let topMostVC = UIApplication.topViewController()
            if !(topMostVC?.isKind(of: SignInViewController.self))! {
                self.openFromNoti(userInfo: userInfo)
            }
        } else {
            FCMUtilities.receiveNotificationFromBackground(userInfo: userInfo as [NSObject : AnyObject])
            if startTimer != nil{
                stopTimer = NSDate()
                if let isSessionExpire = isSessionExpire(startTimer!, stopTimer!) as Bool?{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let signin = storyBoard.instantiateViewController(withIdentifier: "main") as! SignInViewController
                    let topMostVC = UIApplication.topViewController()
                    print("topMost: \(String(describing: topMostVC))")
                    if isSessionExpire || (topMostVC?.isKind(of: SignInViewController.self))!{
                        signin.openFromNoti = true
                        //                        signin.userInfo = userInfo as! [String : AnyObject]
                        self.window?.rootViewController = signin
                    } else {
                        self.openFromNoti(userInfo: userInfo)
                    }
                }
            }
        }
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {

        InstanceID.instanceID().instanceID { (refreshToken, error) in
            if error == nil {
                CredentialManager.shareInstance.fcmToken = refreshToken?.token ?? CredentialManager.shareInstance.fcmToken
                FCMUtilities.connectToFcm()
            }
        }
        /*
        if let refreshedToken = InstanceID.instanceID().token() {
            log.debug("InstanceID token: \(refreshedToken)")
            
            // store token in memory
            CredentialManager.shareInstance.fcmToken = refreshedToken
            
            // Connect to FCM since connection may have failed when attempted before having a token.
            FCMUtilities.connectToFcm()
        }*/
    }
    
    func openFromNoti(userInfo: [AnyHashable : Any]){
        let temp = userInfo as! [String : AnyObject]
        if let aps = temp["action_data"] as? String {
            let apsArray = aps.components(separatedBy: "|")
            if let vcName = apsArray[1] as? String {
                GlobalVar.sharedInstance.page = vcName.lowercased()
                GlobalVar.sharedInstance.purchaseIDNoti = apsArray[0]
                GlobalVar.sharedInstance.openFromNoti = true
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let frontview = storyboard.instantiateViewController(withIdentifier: "frontview") as UIViewController
                let vc = storyboard.instantiateViewController(withIdentifier: "newdashboard") as! NewDashboardViewController
                let frontview = UINavigationController.init(rootViewController: vc)
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                //let navigationController = UINavigationController(rootViewController: frontview)
                //window?.rootViewController = navigationController
                window?.rootViewController = frontview
            }
        }
    }
    /*
    func getAPIBadge(Type : String){
        DispatchQueue.main.async {
            let toDay = Date()
            let targetDate = DataUtils.shared.getLast3MonthDate(date: toDay)
            let strDay = DataUtils.shared.getStringFromDate(date: toDay)
            let strTargetDay = DataUtils.shared.getStringFromDate(date: targetDate)
            
            
            APIManager.shareInstance.getCountTxn(Type: Type,fromDate: strTargetDay, toDate: strDay , callback: { (success, xmlError, dataDict) in
                if success {
                    if (dataDict.count > 0) {
                        var count = 0
                        let dataArray = dataDict[System.CountTxn] as! [String : String]
                        for x in dataArray{
                            count += Int(x.value)!
                        }
                        print ("Success")
                        UIApplication.shared.applicationIconBadgeNumber += count
                    }
                }else{
                    print("Error")
                }
            })
        }
    }*/
    /*
    func reloadBadge() {
        // Update badge value
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.getAPIBadge(Type: "CRUDE_P")
        self.getAPIBadge(Type: "CHARTERING")
        self.getAPIBadge(Type: "BUNKER")
        self.getAPIBadge(Type: "HEDGING")
    }*/
    
    
    func MockOpenFromNoti(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        GlobalVar.sharedInstance.page = "paf"
        GlobalVar.sharedInstance.purchaseIDNoti = "PAF-1802-0007"
        GlobalVar.sharedInstance.openFromNoti = true
        //let frontview = storyboard.instantiateViewController(withIdentifier: "frontview") as UIViewController
        let vc = storyboard.instantiateViewController(withIdentifier: "newdashboard") as! NewDashboardViewController
        let frontview = UINavigationController.init(rootViewController: vc)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        //let navigationController = UINavigationController(rootViewController: frontview)
        //window?.rootViewController = navigationController
        window?.rootViewController = frontview
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //UIApplication.shared.applicationIconBadgeNumber += 1
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        CredentialManager.shareInstance.fcmToken = fcmToken
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
    }
}

public func isSessionExpire(_ start: NSDate, _ stop: NSDate) -> Bool{
    let timeExpire: Double = 60 * 30
    let interval = stop.timeIntervalSince(start as Date)
    print(start)
    print(stop)
    print(interval)
    if interval >= timeExpire {
        return true
    }
    return false
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
