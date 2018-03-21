//
//  AppDelegate.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupIQKeyboard()
        setuGaoDe()
        setupYunxin()
        setupJpush(launchOptions: launchOptions)
        return true
    }
}

//MARK: - window相关
extension AppDelegate {
    
    func setupWindow() {
        window = UIWindow.init(frame: screenBounds)
        window?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        
        if AccountTool.isLogin() == false {
            //弹出登录界面
            let loginNC = NavigationController.init(rootViewController: LoginViewController())
            mainVC.present(loginNC, animated: false, completion: nil)
        } else {
            let roleName = AccountTool.userInfo().roleName!
            mainVC.roleName = roleName
        }
    }
    
    func setupIQKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "完成"
    }
    
    func setuGaoDe() {
        LocationTool.regist()
    }
    
    func setupYunxin() {
        //注册
        let option = NIMSDKOption.init(appKey: yunXinAppkey)
        option.apnsCername = nil
        option.pkCername = nil
        NIMSDK.shared().register(with: option)
        //打印日志
//        NIMSDK.shared().enableConsoleLog()
        //自动登录
        if AccountTool.isLogin() {
            NIMSDK.shared().loginManager.autoLogin(AccountTool.userInfo().phone, token: AccountTool.userInfo().password)
        }
        
        
    }
}

//MARK: - 极光相关
extension AppDelegate: JPUSHRegisterDelegate {
    //设置推送
    func setupJpush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        let entity = JPUSHRegisterEntity()
        entity.types = (Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue))
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: jPushAppKey, channel: "ios", apsForProduction: true)
//        JPUSHService.setAlias(AccountTool.userInfo().phone, completion: { (iResCode, iTags, iAlias) in
//            print(iResCode)
//        }, seq: 0)
        
    }
    
    //MARK: - UIApplicationDelegate
    //注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    //注册失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册 APNS 失败 : \(error)")
        
    }
    
    //进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)//清空JPush服务器中存储的badge值
    }
    
    //进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)//清空JPush服务器中存储的badge值
    }
    
    //程序处于前台运行状态，收到远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //调用极光推送
        JPUSHService.handleRemoteNotification(userInfo)
        
    }
    
    //程序处于后台或者被杀死状态，收到远程通知后，进入(launch)程序
    //如果两个代理方法都被实现了，系统将只调用该方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        //调用极光推送
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    //MARK: - JPUSHRegisterDelegate
    //程序处于前台运行状态，收到远程通知后
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        //提醒方式设置(Badge、Sound、Alert)
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)|Int(UNNotificationPresentationOptions.badge.rawValue)|Int(UNNotificationPresentationOptions.sound.rawValue))
        //消息内容暂不做处理
    }
    
    @available(iOS 10.0, *)
    //程序处于后台或者被杀死状态，收到远程通知后
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        //消息内容
        let userInfo = response.notification.request.content.userInfo
        //判断远程推送
        if let _ = response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) {
            receiveNotification(userInfo: userInfo)
        }else{
            //本地推送
        }
        //不必设置提醒方式
        completionHandler()
    }
    
    //收到通知后跳转相关页面
    func receiveNotification(userInfo : Dictionary<AnyHashable, Any>){
        JPUSHService.handleRemoteNotification(userInfo)
        let model = PushModel.parse(dict: userInfo)        
        //跳转
        let roleName = AccountTool.userInfo().roleName!
        switch roleName {
        case .driver:
            let tabbarVC = mainVC.childViewControllers[0] as! DTabBarController
            tabbarVC.selectedIndex = 0
            print("司机")
        case .clerk:
            clertHandlePush(model: model)
            print("做单员")
        case .manager:
            print("管理员")
        }
    }
    
    func clertHandlePush(model: PushModel) {
        switch model.push_type {
        case "0": //提醒查单
            let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
            tabbarVC.selectedIndex = 0
            
            let homeNav = tabbarVC.viewControllers![0] as! NavigationController
            CToTestifyPopView.show(nav: homeNav, orderId: model.order_id)
        
        default:
            print("🐶")
        }
    }
}
