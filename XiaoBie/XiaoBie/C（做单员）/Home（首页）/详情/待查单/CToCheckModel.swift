//
//  CToCheckModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/30.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class CChatSessionResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = ""
    
    class func parse(dict : Any ) -> CChatSessionResponseModel{
        let model = CChatSessionResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
