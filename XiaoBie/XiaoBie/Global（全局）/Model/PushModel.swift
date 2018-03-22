//
//  PushModel.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2018/1/17.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class PushModel: NSObject,YYModel {

    @objc var order_id = ""
    @objc var response_type = ""
    @objc var push_type = ""
    @objc var type = ""

    class func parse(dict : Any ) -> PushModel{
        let model = PushModel.yy_model(withJSON: dict)
        return model!
    }
}
