//
//  GrabModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class GrabResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var message = ""
    @objc var result = ""
    @objc var data: [GrabModel] = []
    
    class func parse(dict : Any ) -> GrabResponseModel{
        let model = GrabResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":GrabModel.self]
    }
}

class GrabModel: NSObject {
   
    @objc var address = ""
    @objc var agent_dept = ""
    @objc var agent_id = ""
    @objc var agent_name = ""
    @objc var appoint_remark = ""
    @objc var appoint_time = ""
    @objc var average_cost = ""
    @objc var average_flow = ""
    @objc var call_status = ""
    @objc var create_time = ""
    @objc var data_source = ""
    @objc var distance = ""
    @objc var gtcdw = ""
    @objc var id = ""
    @objc var id_number = ""
    @objc var last_revisit_time = ""
    @objc var latitude = ""
    @objc var longitude = ""
    @objc var order_checker_id = ""
    @objc var order_deliver_id = ""
    @objc var original_plan = ""
    @objc var payment = ""
    @objc var phone1 = ""
    @objc var phone2 = ""
    @objc var plan_bind_time = ""
    @objc var project_name = ""
    @objc var project_type = ""
    @objc var remain_balance = ""
    @objc var remark = ""
    @objc var result = ""
    @objc var sex = ""
    @objc var status = ""
    @objc var unique_id = ""
    @objc var update_time = ""
    @objc var user_name = ""
}

