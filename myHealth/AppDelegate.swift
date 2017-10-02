//
//  AppDelegate.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import StreamingKit
import AFNetworking
import SVProgressHUD

let APPKEY = "59b5f7e88f4a9d5ce50000ae"
let SECRET = "vox7lnro4h8itl0suagehex71vsmwjyl"



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    //    var blockRotation: Bool = false
    
    let reachability = Reachability()!
    
    var alertView: UIAlertController?
    
    var audioPlay = STKAudioPlayer();
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
            //添加友盟推送
            self.addUMessage()
            //添加友盟统计
            self.addUMMobClick()
            
            self.window?.backgroundColor = UIColor.white
        
        
        //网络监听
        self.networkStatusListener()
        
        
        
        let session = AVAudioSession.sharedInstance()
        do{
            
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
        }catch{
            print(error)
        }
        
        
        return true
    }
    
    
    func addUMessage() {
        
        let version = UIDevice.current.systemVersion
        
        if (version as NSString).doubleValue < 10.0{
            
            UMessage.start(withAppkey: APPKEY, launchOptions: nil)
            UMessage.registerForRemoteNotifications()
            
            let action1 = UIMutableUserNotificationAction()
            action1.identifier = "action1_identifier"
            action1.title = "打开应用"
            action1.activationMode = UIUserNotificationActivationMode.foreground
            
            let action2 = UIMutableUserNotificationAction()
            action2.identifier = "action2_identifier"
            action2.title = "忽略"
            action2.activationMode = UIUserNotificationActivationMode.background
            action2.isAuthenticationRequired = true
            action2.isDestructive = true
            
            let actionCategory1 = UIMutableUserNotificationCategory()
            actionCategory1.identifier = "category1"
            actionCategory1.setActions([action1,action2], for: UIUserNotificationActionContext.default)
            let categories = NSSet(object: actionCategory1)
            
            UMessage.register(forRemoteNotifications: categories as? Set<UIUserNotificationCategory>)
            
        }else{
            UMessage.start(withAppkey: APPKEY, launchOptions: nil)
            UMessage.registerForRemoteNotifications()
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                let types10:UNAuthorizationOptions = [UNAuthorizationOptions.badge,UNAuthorizationOptions.alert,UNAuthorizationOptions.sound]
                center.requestAuthorization(options: types10, completionHandler: { (granted, error) in
                    if granted{
                        
                    }else{
                        
                    }
                })
                
                let action1_ios10 = UNNotificationAction(identifier: "action1_ios10_identifier", title: "打开应用", options: UNNotificationActionOptions.foreground)
                let action2_ios10 = UNNotificationAction(identifier: "action2_ios10_identifier", title: "忽略", options: .foreground)
                
                let category1_ios10 = UNNotificationCategory(identifier: "category101", actions: [action1_ios10,action2_ios10], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
                
                let categories_ios10 = NSSet(object: category1_ios10)
                center.setNotificationCategories(categories_ios10 as! Set<UNNotificationCategory>)
                
            }
            
            
            
        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        UMessage.didReceiveRemoteNotification(userInfo)
        
        let ud = UserDefaults.standard
        ud.set("\(userInfo)", forKey: "UMPuserInfoNotification")
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        
        let ud = UserDefaults.standard
        ud.set("\(userInfo)", forKey: "UMPuserInfoNotification")
        
        completionHandler([UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.badge])
    }
    
    
    //添加友盟统计
    func addUMMobClick() {
        MobClick.setLogEnabled(true)
        UMAnalyticsConfig.sharedInstance().appKey = APPKEY;
        
        UMAnalyticsConfig.sharedInstance().channelId = "App Store";
        
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsdataStr = NSData.init(data: deviceToken)
        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("deviceToken:\(datastr)")
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "myHealth")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    //网络监听
    
    func networkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            
            UserDefaults.standard.set("YES", forKey: "isFirst")
            self.haveNetWork()
            UserDefaults.standard.set("NO", forKey: "NoNetWork")
            
        } else {
            print("网络连接：不可用")
            UserDefaults.standard.set("YES", forKey: "NoNetWork")
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NoNetVC")
            UIApplication.shared.keyWindow?.rootViewController = viewController
            
            
            
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                
                
                self.noNetWork()
            }
        }
    }
    
    // 警告框，提示没有连接网络 *********************
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "请打开网络连接", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        //        self.present(alert, animated: true, completion: nil)
    }
    
    //没有网络
    func noNetWork() {
        
        if UserDefaults.standard.object(forKey: "isFirst") == nil{
        
            UserDefaults.standard.set("YES", forKey: "isFirst")
            
            return
        }
        
        alertView = UIAlertController.init(title: "网络断开连接", message: "请检查网络或者蜂窝网络使用权限", preferredStyle: UIAlertControllerStyle.alert);
        let cancleBtn = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            //取消
        }
        let exitBtn = UIAlertAction.init(title: "点击退出", style: UIAlertActionStyle.default) { (action) in
            //退出
            self.exitApp()
        }
        alertView?.addAction(cancleBtn)
        alertView?.addAction(exitBtn)
        
        let alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert+1
        alertWindow.makeKeyAndVisible()
        
        
        alertWindow.rootViewController?.present(alertView!, animated: true, completion: nil)
        
    }
    
    
    //有网了
    func haveNetWork() {
        
        if alertView != nil{
            alertView?.dismiss(animated: true, completion: nil)
        }
        
        if self.getCurrentVC().isKind(of: NoNetViewController.self){
            
//            dataUrl(viewC: self.getCurrentVC())
            Tool.getDataBy(self.getCurrentVC())
            
        }
    }
    
    
    //退出
    func exitApp() {
        
        exit(0)
   
    }
    
    
    //获取当前viewcontroller
    func getCurrentVC() -> UIViewController {
        
        let result: UIViewController
        
        var window = UIApplication.shared.keyWindow
        
        if window?.windowLevel != UIWindowLevelNormal{
            
            let arr = UIApplication.shared.windows;
            
            if arr.count > 0 {
                
                for tmpWin in arr {
                    
                    if(tmpWin.windowLevel == UIWindowLevelNormal){
                        
                        window = tmpWin
                        break
                        
                    }
                    
                }
            }
            
            
        }
        
        let frontView = window?.subviews[0]
        
        let nextResponder = frontView?.next
        
        
        
        if (nextResponder?.isKind(of: object_getClass(UIViewController.self)))!{
            result = nextResponder as! UIViewController
        }else{
            result = (window?.rootViewController)!;
        }
        
        return result
        
        
    }
    
    //接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        
        if UIApplication.shared.applicationState == UIApplicationState.active{
            
            let dic = (userInfo["aps"] as! NSDictionary)["alert"] as! NSDictionary
            
            let alertcon = UIAlertController(title: dic["title"] as? String, message: dic["body"] as? String, preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
                
            })
            
            let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: { (action) in
                
            })
            
            alertcon.addAction(ok)
            alertcon.addAction(cancle)
            
            self.window?.rootViewController?.present(alertcon, animated: true, completion: nil)
            
        }
        
        UserDefaults.standard.set("\(userInfo)", forKey: "UMPuserInfoNotification")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userInfoNotification"), object: self, userInfo: ["userinfo":"\(userInfo)"])
        
        
    }
    
    
}

