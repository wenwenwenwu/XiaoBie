//
//  Extension.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/23.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

extension UIButton {

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //重写判断是否在Button的触碰范围内的方法，将所有小按钮接触面积变为44*44(iOS 人机交互规范里面规定的最小点触面积)
        let bounds = self.bounds
        let widthDelta = 44.0 - bounds.size.width
        let heightDelta = 44.0 - bounds.size.height
        //保证小按钮
        guard widthDelta>0 && heightDelta>0 else { return bounds.contains(point) }
        //insetBy方法返回的CGRect (X:原来frme的X +dx ,Y:原来frme的Y +dy Width:原来frme的Width -2*dx , Height:原来frme的Height -2*dy)。即默认中心不变缩进dx和dy。
        let newBounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return newBounds.contains(point)
    }
}

