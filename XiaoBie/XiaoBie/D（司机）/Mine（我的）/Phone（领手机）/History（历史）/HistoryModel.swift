//
//  HistoryModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/23.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class HistoryResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [HistoryModel] = []
    
    class func parse(dict : Any ) -> HistoryResponseModel{
        let model = HistoryResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":HistoryModel.self]
    }
}

class HistoryModel: NSObject,YYModel {
    
    @objc var agent_id = ""
    @objc var create_time = ""
    @objc var dealer_id = ""
    @objc var delivery_id = ""
    @objc var id = ""
    @objc var memory = ""
    @objc var model = ""
    @objc var order_id = ""
    @objc var other_para = ""
    @objc var serial_no = ""
    @objc var source = ""
    @objc var update_time = ""
}
