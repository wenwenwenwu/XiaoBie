//
//  MHomeModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

import YYModel

class MHomeInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = MHomeInfoModel()
    
    class func parse(dict : Any ) -> MHomeInfoResponseModel{
        let model = MHomeInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
}

class MHomeInfoModel: NSObject {
    
    @objc var complete_order_count = ""
    @objc var undone_order_count = ""
    @objc var total_pay = ""
    @objc var total_unpay = ""
}


