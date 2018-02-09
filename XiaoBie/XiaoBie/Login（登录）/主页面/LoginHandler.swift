//
//  LoginHandler.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class LoginHandler {
    // 登录成功（“登录”-“登录”）
    class func loginSucess(viewController: UIViewController,userInfoModel: UserInfoModel) {
        //保存用户信息
        AccountTool.login(with: userInfoModel)
        //退出登录模块
        viewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //登出成功（“我的”-“设置”-“退出登录”）
    class func logoutSucess(viewController: UIViewController) {
        //删除用户信息
        AccountTool.logout()
        //弹出登录界面
        presentLoginVC()
        //设置先次登录显示页面
        viewController.navigationController?.popViewController(animated: false)
    }
    
    class func presentLoginVC() {
        //loginNC
        let loginVC = LoginViewController()
        let loginNC = NavigationController.init(rootViewController: loginVC)
        //tabbarVC
        let tabbarVC = UIApplication.shared.keyWindow!.rootViewController as!TabBarController
        tabbarVC.selectedIndex = 0
        //present
        tabbarVC.present(loginNC, animated: false, completion: nil)
    }
}
