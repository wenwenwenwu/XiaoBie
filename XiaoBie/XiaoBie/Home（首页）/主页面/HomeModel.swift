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
class HomeClockinResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    
    class func parse(dict : Any ) -> HomeClockinResponseModel{
        let model = HomeClockinResponseModel.yy_model(withJSON: dict)
        return model!
    }    
}

//MARK: - HomeInfoModel
class HomeInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = HomeInfoModel()

    class func parse(dict : Any ) -> HomeInfoResponseModel{
        let model = HomeInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":HomeInfoModel.self]
    }
}

class HomeInfoModel: NSObject {
    
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
