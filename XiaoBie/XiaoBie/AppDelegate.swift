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
        //打印日志
//        NIMSDK.shared().enableConsoleLog()
        //注册云信
        let option = NIMSDKOption.init(appKey: yunXinAppkey)
        option.apnsCername = "develop"
        option.pkCername = nil
        NIMSDK.shared().register(with: option)
        //注册APNs
        let types = UIUserNotificationType.init(rawValue: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue)
        let setting = UIUserNotificationSettings.init(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(setting)
        UIApplication.shared.registerForRemoteNotifications()
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
        //去登录处设置极光推送的audience
        //还要注意在应用的targets-capability-background modes中开启remote notification
    }
    
    //MARK: - UIApplicationDelegate
    //注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        NIMSDK.shared().updateApnsToken(deviceToken)
        
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
        //提醒方式设置(Badge、Sound)
        completionHandler(Int(UNNotificationPresentationOptions.badge.rawValue)|Int(UNNotificationPresentationOptions.sound.rawValue))
        //消息内容
        let userInfo = notification.request.content.userInfo
        //判断远程推送
        if let _ = notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) {
            receiveNotification(userInfo: userInfo)
        }else{
            //本地推送
        }
    }
    
    @available(iOS 10.0, *)
    //程序处于后台或者被杀死状态，收到远程通知后
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        //系统要求设置
        completionHandler()
        //消息内容
        let userInfo = response.notification.request.content.userInfo
        //判断远程推送
        if let _ = response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) {
            receiveNotification(userInfo: userInfo)
        }else{
            //本地推送
        }
    }
    
    //MARK: - Action
    //收到通知后跳转相关页面
    func receiveNotification(userInfo : Dictionary<AnyHashable, Any>){
        JPUSHService.handleRemoteNotification(userInfo)
        let model = PushModel.parse(dict: userInfo)
        switch model.push_type {
        case "0": //提醒做单员查单
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "通知", message: "你有一个待查单", functionButtons: ["知道了", "去查单"], cancelButton: nil, closure: { (buttonTitle) in
                switch buttonTitle {
                case "去查单":
                    let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
                    let selectedNav = tabbarVC.selectedViewController as! NavigationController
                    self.pushCToCheckOrderDetailRequest(nav: selectedNav, orderId: model.order_id)
                case "知道了":
                    self.clerkHomeVCReloadData()
                default:
                    break
                }
            })
        case "2": //提醒做单员验单
            Alert.showAlertWith(style: .actionSheet, controller: mainVC, title: "通知", message: "司机请求验单", functionButtons: ["正在忙", "请稍等", "去验单"], cancelButton: nil, closure: { (buttonTitle) in
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
                    self.pushCToTestifyVCWithCode(nav: selectedNav, orderId: model.order_id)
                default:
                    break
                }
                self.setClerkStatus(clerkStatus: clerkStatus, orderId: model.order_id)
            })
        case "1": //提醒做单员返回验证码已发送
            let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
            let selectedNav = tabbarVC.selectedViewController as! NavigationController
            self.pushCToTestifyVCWithCode(nav: selectedNav, orderId: model.order_id)
            
        case "10": //提醒做单员已付款
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "订单已付款", message: "请确认", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                let tabbarVC = mainVC.childViewControllers[0] as! CTabBarController
                let selectedNav = tabbarVC.selectedViewController as! NavigationController
                self.pushCCompleteVC(nav: selectedNav, orderId: model.order_id)
            })
            
        case "8": //提醒司机/做单员订单取消
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "订单已取消", message: "请在首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                switch AccountTool.userInfo().roleName! {
                case .driver:
                    currentController?.navigationController?.popToRootViewController(animated: true)//因为无法手动返回
                    self.driverHomeVCReloadData()
                case .clerk:
                    self.clerkHomeVCReloadData()
                default:
                    break
                }
            })
        
        case "3": //提醒司机验证码已发送
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "验证码已发送", message: "请客户注意查收", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.pushDCodeVC(nav: (currentController?.navigationController)!, orderId: model.order_id)
            })
            
        case "5": //提醒司机当前验单状态
            guard  currentController != nil else { return } //忽略手动刷新变为通过状态时返回的推送
            let dToTestifyVC = currentController as! DToTestifyViewController
            //显示状态·
            dToTestifyVC.currentClerkCell?.updateClerkStatus(statusType: model.response_type)
            //换人操作
            switch model.response_type {
            case "0", "1"://正在忙、请稍等
                //立刻换人
                dToTestifyVC.remindButton.status = .enabled
            case "2"://正常
                //无法换人、无法提醒验单
                dToTestifyVC.remindButton.status = .disabled
            default:
                break
            }
            
        case "6": //提醒司机验单完成
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "通知", message: "验单已完成", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.pushDUploadVC(nav: (currentController?.navigationController)!, orderId: model.order_id)
            })
            
        case "7": //提醒司机查单完成
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "查单已完成", message: "请在首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
                self.driverHomeVCReloadData()
            })
            
        case "9": //提醒司机订单完成
            Alert.showAlertWith(style: .alert, controller: mainVC, title: "订单已完成", message: "请在首页查看", functionButtons: ["知道了"], cancelButton: nil, closure: { (_) in
               self.driverHomeVCReloadData()
            })
            
        default:
            break
        }
    }
    
    //MARK: - Action Method
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
    
    //做单员端推出待查单
    func pushCToCheckOrderDetailRequest(nav: UINavigationController, orderId: String) {
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
    
    //做单员端推出待验单(发送验证码)
    func pushCToTestifyVCWithCode(nav: UINavigationController, orderId: String) {
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
    
    //做单员设置当前状态
    func setClerkStatus(clerkStatus: String, orderId: String) {
        WebTool.post(uri:"resp_verify_pop_win", para:["oper_type": clerkStatus, "staff_id": AccountTool.userInfo().id, "order_id": orderId], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //做单员端推出待付款
    func pushCCompleteVC(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let completeVC = CCompleteViewController()
                completeVC.model = model.data
                nav.pushViewController(completeVC, animated: false)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //司机端推出输入验证码页面
    func pushDCodeVC(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let codeVC = DCodeViewController()
                codeVC.model = model.data
                nav.pushViewController(codeVC, animated: false)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //司机端推出上传凭证页面
    func pushDUploadVC(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let uploadVC = DUploadViewController()
                uploadVC.model = model.data
                nav.pushViewController(uploadVC, animated: false)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
}
