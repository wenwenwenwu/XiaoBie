//
//  DHistoryModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/23.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class DHistoryResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DHistoryModel] = []
    
    class func parse(dict : Any ) -> DHistoryResponseModel{
        let model = DHistoryResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DHistoryModel.self]
    }
}

class DHistoryModel: NSObject,YYModel {
    
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
    @objc var source_id = ""
    @objc var store_admin_id = ""
    @objc var admin_name = ""
}
