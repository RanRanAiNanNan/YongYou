 //
//  AppDelegate.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/17.
//  Copyright © 2016年 然. All rights reserved.
//

 import UIKit
 import CoreData
 import SwiftyDrop
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate{
    
    var notificationDic: NSDictionary!                          //存储推送数据
    
    var window: UIWindow?
    
    var recervedData: NSMutableData?
    
    var checkVersionService = CheckVersionService.getInstance()
    
    var currentVersion: NSString?
    
    let appKey = "ik1qhw091efap"
    
    var direction: Bool = false
    
    var myApp:AppDelegate?
    
    var SwiftyDrop : Int = 0
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //跳转的
        userDefaultsUtil.setTiaoZhuan("")
        
       

        
//        [UMessage unregisterForRemoteNotifications]
        
        
        // Override point for customization after application launch.
        //每次进来让远程推送的message为空
        userDefaultsUtil.setNotificationMessageKey("")
        //启动界面停留时间
        NSThread.sleepForTimeInterval(1)
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        UMessage.setLogEnabled(true)
        
        //status bar 样式
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//        MobClick.setCrashReportEnabled(false)
        //友盟推送
        UMessage.startWithAppkey(B.UMENG_MESSAGE_KEY, launchOptions: launchOptions)
        //融云
        //RCIM.initWithAppKey(B.RONGCLOUD_APP_KEY, deviceToken: nil)
        //友盟
        UMSocialData.setAppKey(B.UMENG_APP_KEY)
        //新浪
//        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey(B.SINA_APP_ID, secret: B.SINA_APP_SECRET, redirectURL: B.SINA_APP_CALLBACK)
        //微信
        UMSocialWechatHandler.setWXAppId(B.WX_APP_ID, appSecret: B.WX_APP_KEY, url: "www.yinduoziben.com")
        //QQ
//        UMSocialQQHandler.setQQWithAppId(B.QQ_APP_ID, appKey: B.QQ_APP_KEY, url: "www.yinduoziben.com")
        //qq及微信未安装客户端平台进行隐藏
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline])
        
         //在 iOS 8 下注册苹果推送，申请推送权限。UIUserNotificationType
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//        友盟统计
//        MobClick.startWithAppkey(B.UMENG_APP_KEY, reportPolicy: SEND_INTERVAL, channelId: "App Store")
        //美洽客服
//        MQManager.initWithAppkey(B.MEIQIA_APP_KEY) { (clientId, error) -> Void in
//            if error == nil {
//                //                print("美洽 SDK：初始化成功")
//            }
//        }
        
        //checkVersion()
        
        let action1 = UIMutableUserNotificationAction()
        action1.identifier = "action1_identifier"
        action1.title = "Accept"
        //当点击的时候启动程序
        action1.activationMode = UIUserNotificationActivationMode.Foreground
        
        let action2 = UIMutableUserNotificationAction()
        action2.identifier = "action2_identifier"
        action2.title = "Reject"
        //当点击的时候不启动程序，在后台处理
        action2.activationMode = UIUserNotificationActivationMode.Background
        //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.authenticationRequired = true
        action2.destructive = true
        
        let categorys = UIMutableUserNotificationCategory()
        //这组动作的唯一标示
        categorys.identifier =  "category1"
        categorys.setActions([action1,action2], forContext: UIUserNotificationActionContext.Default)
        let userSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: NSSet(object: categorys) as? Set<UIUserNotificationCategory>)
        
        UMessage.registerRemoteNotificationAndUserNotificationSettings(userSettings)
        
        UMessage.setAutoAlert(false)
        
        if launchOptions != nil {
            let localNotif = launchOptions! as NSDictionary
            notificationDic = localNotif.valueForKey(UIApplicationLaunchOptionsRemoteNotificationKey) as? NSDictionary
            
        }
        
        
        //判断用户是否第一次登录
        if(userDefaultsUtil.isFirstLogged()){
//            userDefaultsUtil.setZhangHao("")
            userDefaultsUtil.setTuiSong("开")
//            //清除手势
            KeychainWrapper.removeObjectForKey(kSecValueData as String)
            //跳转到引导页
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("guide") as! GuideViewController
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
            //否则判断是否末登录过
        }else if !userDefaultsUtil.isLoggedIn() {

            //跳转到登录页面
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("mainCtrl") as! MainViewController
            self.window!.rootViewController = viewController
            self.window!.makeKeyAndVisible()
        }
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveNewMQMessages:", name: MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION, object: nil)
        
        //友盟添加使用别名
        UMessage.addAlias(userDefaultsUtil.showMobile(), type: kUMessageAliasTypeSina) {
            (responseObject, error) -> Void in
            print(error)
            print("alias登陆成功")
        }
        print(userDefaultsUtil.getTuiSong()!)
        if userDefaultsUtil.getTuiSong()! == "开"{
            
        }else{
          UMessage.unregisterForRemoteNotifications()
        }
        
        
        
        return true
    }
    
    func meiqiaLogin(userId: String){
        //print("登录过的用户")
//        MQManager.setClientOnlineWithCustomizedId(userDefaultsUtil.showMobile(), success: { (result, agent, messages) -> Void in
//            //print("客服登陆成功")
//            }, failure: { (error) -> Void in
//                //print("客服登陆失败:\(error.code)")
//            }, receiveMessageDelegate: self)
        
    }
    
//    func didReceiveMQMessages(message: [MQMessage]!) {}
    
    //接收美洽客服广播并发送本地通知
    func didReceiveNewMQMessages(notification: NSNotification){
        //print("触发监听MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION广播事件")
//        let messages = notification.userInfo!["messages"] as? [MQMessage]
        let noReadNum = UIApplication.sharedApplication().applicationIconBadgeNumber
//        for  message in messages! {
//            //print("广播内容:\(message.content)")
//            let localNotification = UILocalNotification()
//            localNotification.alertBody = message.content
//            localNotification.applicationIconBadgeNumber = noReadNum + 1
//            localNotification.soundName = UILocalNotificationDefaultSoundName
//            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
//        }
        if (SwiftyDrop == 0){
////            let messages = notification.userInfo!["messages"] as? [MQMessage]
//            for  message in messages! {
//                if (message.content as NSString).length < 43 {
//                    Drop.down("  \(message.content)")
//                }else{
//                    let nsstring = (message.content as NSString).substringToIndex(43)
//                    Drop.down("  \(nsstring)...")
//                }
//            }
        }else{
            
        }
        
    }
    
    func checkVersion(){
        recervedData = NSMutableData()
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        currentVersion = infoDict.objectForKey("CFBundleShortVersionString") as! String
        checkVersionService.checkVersion({
            version in
            if version > self.currentVersion?.floatValue {
                AlertUtil.simpleAlert(self, title: "通知", msg: "有新的版本发布，是否前往更新？", okBtnTitle: "前往更新", cancelBtnTitle: "取消")
            }
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 110 {
            if buttonIndex == 1 {
                let center = NSNotificationCenter.defaultCenter()
                center.postNotificationName(UIApplicationDidBecomeActiveNotification, object: nil)
            }else{
                notificationDic = nil
            }
        }else{
            if buttonIndex == 0 {
                //userDefaultsUtil.exitSetting()
                let url:NSURL = NSURL(string: B.STORE_DOWNLOAD_ADDRESS + B.APP_ID)!
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        //RCIM.sharedRCIM().setDeviceToken(deviceToken)
//        MQManager.registerDeviceToken(deviceToken)
        UMessage.registerDeviceToken(deviceToken)
        
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceToken = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet( characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        print("deviceToken:\(deviceToken)")
        
    }
    //收到远程通知然后调用这个方法
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if !userInfo.isEmpty {
            notificationDic = userInfo as NSDictionary
//            UMessage.didReceiveRemoteNotification(userInfo)
            switch application.applicationState {
                //在活跃的状态下
            case UIApplicationState.Active:
                if let type = notificationDic.valueForKey("type") as? String {
                    switch type {
                    case "1":
                        if let name = notificationDic.valueForKey("name") as? String {
                            if !userDefaultsUtil.isLoggedIn() {
                                KGXToast.showToastWithMessage("请您登录后在发现中查看\'\(name)\'内容!", duration: ToastDisplayDuration.LengthShort)
                                return
                            }
                            if let _ = notificationDic.valueForKey("url") as? String {
                                let title = ("前去 ［\(name)］ 看看")
                                let av = UIAlertView(title: "", message: title, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "前去")
                                av.tag = 110
                                av.show()
                            }
                        }
                    case "3":
                        if let _ = notificationDic.valueForKey("url") as? String {
                            if !userDefaultsUtil.isLoggedIn() {
                                KGXToast.showToastWithMessage("请您登录后在公告中查看详细内容!", duration: ToastDisplayDuration.LengthShort)
                                return
                            }
                            let title = ("前去公告中看看")
                            let av = UIAlertView(title: "", message: title, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "前去")
                            av.tag = 110
                            av.show()
                        }
                        
                    default:
                        break
                    }
                    
                }
                //在不活跃的程序状态
            case UIApplicationState.Inactive:
                let center = NSNotificationCenter.defaultCenter()
                center.postNotificationName(UIApplicationDidBecomeActiveNotification, object: nil)
                
            default:
                break
            }
        }
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SwiftSpinner.hide()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveNewMQMessages:"), name: MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION, object: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        SwiftyDrop = 1
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        SwiftyDrop = 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //MQManager.openMeiqiaService()
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION, object: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //  MQManager.openMeiqiaService()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //        print("\(error)")
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.yinduoziben.ios_gitTest" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ydzbapp_hybrid", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ios_gitTest.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
 }
 
