//
//  NavigationController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController,UINavigationBarDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        //标题字体
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:black_333333,NSAttributedStringKey.font: font18Medium]
        //背景色
        navigationBar.setBackgroundImage(ColorImageTool.imageWithColor(color: white_FFFFFF), for: UIBarMetrics.default)
        //分割线颜色
        navigationBar.shadowImage = ColorImageTool.imageWithColor(color: gray_F0F0F0)
    }
    
    //MARK: - Action
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //返回按钮（为了适配iOS10.3.3系统bug）
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_return").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonAction(animated:)))
        //隐藏tabbar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }else {
            viewController.navigationItem.leftBarButtonItem = nil
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backButtonAction(animated: Bool) {
        popViewController(animated: true)
    }
    
    
}

