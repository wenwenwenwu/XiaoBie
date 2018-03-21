//
//  MTOTestifyPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/21.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MTOTestifyPopView: UIView {

    func show(controller: UIViewController) {
        Alert.showAlertWith(style: .alert, controller: controller, title: "通知", message: "您有一个待查单", functionButtons: ["去查单"], cancelButton: "知道了") { _ in
            print("查单")
        }
    }

}
