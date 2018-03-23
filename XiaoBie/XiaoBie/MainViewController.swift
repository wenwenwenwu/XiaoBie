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
    
    //MARK: - Request
    func lockedOrderRequest() {
        WebTool.post(uri: "lock_order_for_deliver", para: ["staff_id" : AccountTool.userInfo().id], success: { (dict) in
            let model = LockedOrderResponseModel.parse(dict: dict)
            if model.code == "0" && !model.data.isEmpty {
                self.orderDetailRequest(lockedModel: model.data[0])
            } else {
                let dTabBarVC = DTabBarController()
                self.addChildViewController(dTabBarVC)
                self.view.addSubview(dTabBarVC.view)
            }
        }) { (error) in
            let dTabBarVC = DTabBarController()
            self.addChildViewController(dTabBarVC)
            self.view.addSubview(dTabBarVC.view)
        }
    }
    
    func orderDetailRequest(lockedModel: LockedOrderModel) {
        WebTool.post(uri:"get_order_detail", para:["order_id": lockedModel.id], success: { (dict) in
            let model = COrderDetailResponseModel.parse(dict: dict)
            if model.code == "0" {
                let status = lockedModel.status
                switch status {
                case "7": //待验单之验证码页面
                    let codeVC = DCodeViewController()
                    codeVC.model = model.data
                    let nav = NavigationController.init(rootViewController: codeVC)
                    self.addChildViewController(nav)
                    self.view.addSubview(nav.view)
                case "8", "11": //待验单之上传凭证页面
                    let uploadVC = DUploadViewController()
                    uploadVC.model = model.data
                    let nav = NavigationController.init(rootViewController: uploadVC)
                    self.addChildViewController(nav)
                    self.view.addSubview(nav.view)
                case "13", "14": //待验单之付款页面
                    let payVC = DPayViewController()
                    payVC.model = model.data
                    let nav = NavigationController.init(rootViewController: payVC)
                    self.addChildViewController(nav)
                    self.view.addSubview(nav.view)
                default:
                    break
                }
            } else {
                let dTabBarVC = DTabBarController()
                self.addChildViewController(dTabBarVC)
                self.view.addSubview(dTabBarVC.view)            }
        }) { (error) in
            let dTabBarVC = DTabBarController()
            self.addChildViewController(dTabBarVC)
            self.view.addSubview(dTabBarVC.view)        }
    }

    //MARK: - Properties
    var roleName: Role = .driver {
        didSet {
            switch roleName {
            case .driver:
                lockedOrderRequest()
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
