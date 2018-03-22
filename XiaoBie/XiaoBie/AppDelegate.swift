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

var currentController: UIViewController?


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
        JPUSHService.setAlias(AccountTool.userInfo().phone, completion: { (iResCode, iTags, iAlias) in
            print(iResCode)
        }, seq: 0)
        
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
    
    //MARK: - Action Method
    //收到通知后跳转相关页面
    func receiveNotification(userInfo : Dictionary<AnyHashable, Any>){
        JPUSHService.handleRemoteNotification(userInfo)
        let model = PushModel.parse(dict: userInfo)
        switch model.push_type {
        case "0": //提醒做单员查单
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "通知", message: "你有一个待查单", functionButtons: ["知道了"], cancelButton: nil, closure: { (buttonTitle) in
                switch buttonTitle {
                case "去查单":
                    let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
                    let selectedNav = tabbarVC.selectedViewController as! NavigationController
                    self.pushToCheckOrderDetailRequest(nav: selectedNav, orderId: model.order_id)
                case "知道了":
                    self.clerkHomeVCReloadData()
                default:
                    break
                }
            })
        case "1": //提醒做单员返回验证码已发送
            let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
            let selectedNav = tabbarVC.selectedViewController as! NavigationController
            self.pushToTestifyVCWithCode(nav: selectedNav, orderId: model.order_id)
        case "2": //提醒做单员验单
            Alert.showAlertWith(style: .actionSheet, controller: mainVC, title: "待验单", message: "司机小王请求验单", functionButtons: ["正在忙", "请稍等", "去验单"], cancelButton: nil, closure: { (buttonTitle) in
                //clerkStatus
                var clerkStatus = ""
                switch buttonTitle {
                case "正在忙":
                    clerkStatus = "0"
                case "请稍等":
                    clerkStatus = "1"
                case "去验单":
                    clerkStatus = "2"
                    let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
                    let selectedNav = tabbarVC.selectedViewController as! NavigationController
                    self.pushToTestifyVCWithCode(nav: selectedNav, orderId: model.order_id)
                default:
                    break
                }
                self.setClerkStatus(clerkStatus: clerkStatus, orderId: model.order_id)

            })
        case "3": //提醒司机验证码已发送（未完成）
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "验证码已发送", message: "请客户注意查收", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
            })
        case "5": //提醒司机当前验单状态（未完成）
            break
        case "6": //提醒司机验单完成（未完成）
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "验单已完成", message: "请到首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.driverHomeVCReloadData()
            })
        case "7": //提醒司机查单完成
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "查单已完成", message: "请到首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.driverHomeVCReloadData()
            })
        case "8": //提醒做单员订单取消
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "订单已取消", message: "请到首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.clerkHomeVCReloadData()
            })
        case "9": //提醒司机订单完成
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "订单已完成", message: "请到首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
               self.driverHomeVCReloadData()
            })
        case "10": //提醒做单员已付款
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "客户已付款", message: "请到首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.clerkHomeVCReloadData()
            })
        default:
            break
        }
    }
    
    //刷新司机端首页
    func driverHomeVCReloadData() {
        let tabbarVC = mainVC.childViewControllers[0] as! DTabBarController
        let homeNav = tabbarVC.childViewControllers[0] as! NavigationController
        let homeVC = homeNav.viewControllers[0] as! DHomeViewController
        homeVC.reloadData()
    }
    
    //刷新做单员端首页
    func clerkHomeVCReloadData() {
        let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
        let homeNav = tabbarVC.childViewControllers[0] as! NavigationController
        let homeVC = homeNav.viewControllers[0] as! CHomeViewController
        homeVC.reloadData()
    }
    
    //MARK: - Request
    //推出待查单
    func pushToCheckOrderDetailRequest(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let toCheckVC = CToCheckViewController()
                toCheckVC.model = model.data
                nav.pushViewController(toCheckVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //推出待验单(未发送验证码)
    func pushToTestifyVCWithoutCode(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let toTestifyVC = CToTestifyViewController()
                toTestifyVC.model = model.data
                nav.pushViewController(toTestifyVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //推出待验单(发送验证码)
    func pushToTestifyVCWithCode(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let toTestifyVC = CToTestifyViewController()
                toTestifyVC.model = model.data
                toTestifyVC.refreshCode()
                nav.pushViewController(toTestifyVC, animated: false)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //设置验单员当前状态
    func setClerkStatus(clerkStatus: String, orderId: String) {
        WebTool.post(uri:"resp_verify_pop_win", para:["oper_type": clerkStatus, "staff_id": AccountTool.userInfo().id, "order_id": orderId], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    
}
