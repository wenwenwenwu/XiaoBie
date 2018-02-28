//
//  MainViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Properties
    var roleName: Role = .driver {
        didSet {
            switch roleName {
            case .driver:
                let dTabBarVC = DTabBarController()
                self.addChildViewController(dTabBarVC)
                view.addSubview(dTabBarVC.view)
            case .clerk:
                let cTabBarVC = CTabBarController()
                self.addChildViewController(cTabBarVC)
                view.addSubview(cTabBarVC.view)
            case .manager:
                let mTabBarVC = MTabBarController()
                self.addChildViewController(mTabBarVC)
                view.addSubview(mTabBarVC.view)
            }
        }
    }
}
