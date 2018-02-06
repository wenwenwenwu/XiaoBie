//
//  HateResponseModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class HateResponseModel: NSObject,YYModel {
    @objc var msg = ""
    @objc var result = ""
    
    class func parse(dict : Any ) -> HateResponseModel{
        let model = HateResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
