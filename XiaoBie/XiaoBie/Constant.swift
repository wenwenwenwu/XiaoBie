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
    let black_333333 = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    let black_303133 = #colorLiteral(red: 0.1882352941, green: 0.1921568627, blue: 0.2, alpha: 1)
    let gray_666666 = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    let gray_A3A5A8 = #colorLiteral(red: 0.6392156863, green: 0.6470588235, blue: 0.6588235294, alpha: 1)
    let gray_F0F0F0 = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    let gray_F5F5F5 = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)


    let white_FFFFFF = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    //字体
    let font12 = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
    let font14 = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
    let font16 = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)

    let font18Medium = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
    let font10Medium = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
    let font40Bold = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)

    //第三方
    let JPushAppKey = "5a7e0489b11594cb421bccc4"

