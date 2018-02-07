//
//  TabbarController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: Setup
    func setupTabBar() {
        //viewControllers
        let homeNav = NavigationController.init(rootViewController: HomeViewController())
        let orderNav = NavigationController.init(rootViewController: OrderViewController())
        let chatNav = NavigationController.init(rootViewController: ChatViewController())
        let mineNav = NavigationController.init(rootViewController: MineViewController())
        viewControllers = [homeNav,orderNav,chatNav,mineNav]
        
        //title
        homeNav.tabBarItem.title = "首页"
        orderNav.tabBarItem.title = "抢单"
        chatNav.tabBarItem.title = "聊天"
        mineNav.tabBarItem.title = "我的"        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : gray_A3A5A8, NSAttributedStringKey.font : font10Medium], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : blue_3296FA, NSAttributedStringKey.font : font10Medium], for: .selected)
        
        //icon
        homeNav.tabBarItem.image = #imageLiteral(resourceName: "icon_home_default").withRenderingMode(.alwaysOriginal)
        homeNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon_home_selected").withRenderingMode(.alwaysOriginal)
        
        orderNav.tabBarItem.image = #imageLiteral(resourceName: "icon_qd_default").withRenderingMode(.alwaysOriginal)
        orderNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon_qd_selected").withRenderingMode(.alwaysOriginal)
        
        chatNav.tabBarItem.image = #imageLiteral(resourceName: "icon_lt_default").withRenderingMode(.alwaysOriginal)
        chatNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon_lt_selected").withRenderingMode(.alwaysOriginal)
        
        mineNav.tabBarItem.image = #imageLiteral(resourceName: "icon_my_default").withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.selectedImage = #imageLiteral(resourceName: "icon_my_selected").withRenderingMode(.alwaysOriginal)
        
        //background
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: tabbarHeight))
        backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.insertSubview(backView, at: 0)
        tabBar.isOpaque = true
    }
}



