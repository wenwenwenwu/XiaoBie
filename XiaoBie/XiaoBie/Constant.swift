//
//  Constant.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

    //MARK: - 尺寸
    let screenBounds: CGRect = UIScreen.main.bounds
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    let navigationBarHeight: CGFloat = (screenHeight == 812) ? 88 : 64
    let tabbarHeight: CGFloat = (screenHeight == 812) ? 83 : 49
    let toolBarHeight: CGFloat = 44

    //颜色
    let blue_3296FA = #colorLiteral(red: 0.1960784314, green: 0.5882352941, blue: 0.9803921569, alpha: 1)

    //字体
    let font16 = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)

    //第三方
    let JPushAppKey = "5a7e0489b11594cb421bccc4"

