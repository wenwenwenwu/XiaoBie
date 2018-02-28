//
//  HateResponseModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - HomeClockinModel
class DHomeClockinResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    
    class func parse(dict : Any ) -> DHomeClockinResponseModel{
        let model = DHomeClockinResponseModel.yy_model(withJSON: dict)
        return model!
    }    
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
    
    @objc var complete_count = ""
    @objc var need_appoint_count = ""
    @objc var need_query_count = ""
    @objc var need_verify_count = ""
    @objc var original_order_count = ""
    @objc var pay_count_today = ""
    @objc var pay_count_total = ""
    @objc var pay_money_today = ""
    @objc var pay_money_total = ""
    @objc var second_verify_count = ""
    @objc var undone_order_count = ""
}
