//
//  HateResponseModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DHomeClockinStatusModel
class DHomeClockinStatusResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var result = ""
    @objc var msg = ""
    @objc var data = DHomeClockinStatusModel()

    class func parse(dict : Any ) -> DHomeClockinStatusResponseModel{
        let model = DHomeClockinStatusResponseModel.yy_model(withJSON: dict)
        return model!
    }
}

class DHomeClockinStatusModel: NSObject {
    //0表示未签到或签退，1标识已签到或签退
    @objc var up_status = "" //签到状态
    @objc var down_status = "" //签退状态
}

//MARK: - DHomeInfoModel
class DHomeInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = DHomeInfoModel()

    class func parse(dict : Any ) -> DHomeInfoResponseModel{
        let model = DHomeInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DHomeInfoModel.self]
    }
}

class DHomeInfoModel: NSObject {

    @objc var complete_count = "" //完成订单数量
    @objc var need_appoint_count = "" //已查单数量
    @objc var need_query_count = "" //待查单数量
    @objc var need_verify_count = "" //待验单数量
    @objc var original_order_count = "" //可抢单数量
    @objc var pay_count_today = "" //今日结算数
    @objc var pay_count_total = "" //总结算数
    @objc var pay_money_today = "" //今日结算金额
    @objc var pay_money_total = "" //总结算金额
    @objc var market_case_count = "" //添加营销案数量
    @objc var undone_order_count = "" //未完成订单数
}
