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
                self.addChildViewController(dTabBarVC)
                view.addSubview(dTabBarVC.view)
            case .clerk:
                self.addChildViewController(cTabBarVC)
                view.addSubview(cTabBarVC.view)
            case .manager:
                self.addChildViewController(mTabBarVC)
                view.addSubview(mTabBarVC.view)
            }
        }
    }
}
