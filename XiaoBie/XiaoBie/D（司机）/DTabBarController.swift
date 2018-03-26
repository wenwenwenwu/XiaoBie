//
//  TabbarController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupLocationTracker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    deinit {        
        print("🐱")
    }
    
    //MARK: - Action
    @objc func updateLocationAction() {
        locationTool.startUpdatingLocation()
    }
    
    func locationToolCompleteLocationEvent(latitude: String, longitude: String) {
        uploadLocationRequest(latitude: latitude, longitude: longitude)
    }
    
    //MARK: - Request
    func uploadLocationRequest(latitude: String, longitude: String) {
        //默默上传位置
        WebTool.post(isShowHud: true, uri: "real_time_location", para: ["staff_id": AccountTool.userInfo().id, "latitude": latitude, "longitude": longitude], success: { dict in
            let model = DBasicResponseModel.parse(dict: dict)
            print(model.msg)
            
        }) { _ in }
    }
    
    //MARK: Setup
    func setupTabBar() {
        //viewControllers
        let homeNav = NavigationController.init(rootViewController: DHomeViewController())
        let orderNav = NavigationController.init(rootViewController: DGrabViewController())
        let chatNav = NavigationController.init(rootViewController: NIMSessionListViewController())
        let mineNav = NavigationController.init(rootViewController: DMineViewController())
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
    
    func setupLocationTracker() {
        if UIApplication.shared.backgroundRefreshStatus == .denied && UIApplication.shared.backgroundRefreshStatus == .restricted {
            Alert.showAlertWith(style: .alert, controller: self, title: "", message: "本应用还未开启后台应用刷新，请到设置-通用-后台应用刷新中开启", functionButtons: [], cancelButton: "确定", closure: { _ in })
        } else {
            timer.fire()
        }
    }
    
    //MARK: - Properties
    lazy var timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(updateLocationAction), userInfo: nil, repeats: true)
    
    lazy var locationTool = LocationTool.toolWith { [weak self]  (latitude, longitude) in
        self?.locationToolCompleteLocationEvent(latitude: latitude, longitude: longitude)
    }
}



