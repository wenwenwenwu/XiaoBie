//
//  MToTestifyPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/21.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CToTestifyPopView: UIView {

    class func show(nav: UINavigationController, orderId: String) {
        Alert.showAlertWith(style: .alert, controller: nav, title: "通知", message: "您有一个待查单", functionButtons: ["去查单"], cancelButton: "知道了") { _ in
            loadRequest(nav: nav, orderId: orderId)
        }
    }
    
    class func loadRequest(nav: UINavigationController, orderId: String) {
        WebTool.post(uri:"get_order_detail", para:["order_id": orderId], success: { (dict) in
            let model = MOrderDetailResponseModel.parse(dict: dict)
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
    

}

