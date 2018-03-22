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

    @objc var _j_business = ""
    @objc var order_id = ""
    @objc var push_type = ""
    @objc var _j_uid = ""
    @objc var type = ""
    @objc var _j_msgid = ""
    @objc var aps = ""


    class func parse(dict : Any ) -> PushModel{
        let model = PushModel.yy_model(withJSON: dict)
        return model!
    }
}
