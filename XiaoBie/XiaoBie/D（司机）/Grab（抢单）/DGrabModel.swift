//
//  GrabModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class DGrabItemResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var message = ""
    @objc var result = ""
    @objc var data: [DGrabItemModel] = []
    
    class func parse(dict : Any ) -> DGrabItemResponseModel{
        let model = DGrabItemResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DGrabItemModel.self]
    }
}

enum DHomeStatusType {
    /*
     1-待查单;
     2-查询中（做单员端显示待查单）;
     3-已查单;
     4-待验单;
     5-客户取消;
     6-司机联系验单员（司机端显示联系中，做单员端显示待验单）;
     7-验单员收到司机给的弹窗，点击确认后（司机端显示正在验单，做单员端显示待验单）;
     8-通过验证;
     9-无此活动;
     10-已查单(需现场验证,预约完成后还是进入待验单，也就是状态4);
     13-凭证已上传
     14-完成（支付完成）
     15-待添加营销案(确认完成后到达完成状态)
     */
    case toCheck
    case querying
    case checked
    case toTestify
    case cancel
    case contact
    case accept
    case access
    case empty
    case checked2
    case uploaded
    case complete
    case toAdd
}

//抢单、订单列表、修改地址、修改套餐共用
class DGrabItemModel: NSObject {
    
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
    @objc var distance = "" {
        didSet {
            let FloatDistanceKM = Float(distance)!/1000
            distanceKM = String(format: "%.2f", FloatDistanceKM)
        }
    }
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
    @objc var status = "" {
        didSet{
            switch status {
            case "1":
                statusType = .toCheck
            case "2":
                statusType = .querying
            case "3":
                statusType = .checked
            case "4":
                statusType = .toTestify
            case "5":
                statusType = .cancel
            case "6":
                statusType = .contact
            case "7":
                statusType = .accept
            case "8":
                statusType = .access
            case "9":
                statusType = .empty
            case "10":
                statusType = .checked2
            case "13":
                statusType = .uploaded
            case "14":
                statusType = .complete
            default:
                statusType = .toAdd
            }
        }
    }
    @objc var unique_id = ""
    @objc var update_time = ""
    @objc var user_name = ""
    @objc var shipping_method = ""
    @objc var generate_type = ""

    //自定义
    var statusType: DHomeStatusType = .toCheck
    var distanceKM = ""
}

class DBasicResponseModel: NSObject,YYModel {

    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""

    class func parse(dict : Any ) -> DBasicResponseModel{
        let model = DBasicResponseModel.yy_model(withJSON: dict)
        return model!
    }
}

