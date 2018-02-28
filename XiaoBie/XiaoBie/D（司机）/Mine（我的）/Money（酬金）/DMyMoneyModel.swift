//
//  MyMoneyModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DMyMoneyInfoModel
class DMyMoneyInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = DMyMoneyInfoModel()
    
    class func parse(dict : Any ) -> DMyMoneyInfoResponseModel{
        let model = DMyMoneyInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DMyMoneyInfoModel.self]
    }
}

class DMyMoneyInfoModel: NSObject {
    
    @objc var total_pay_count = ""
    @objc var total_pay_money = ""
    @objc var today_pay_count = ""
    @objc var today_pay_money = ""
    @objc var punish_money = ""
}

//MARK: - DMyMoneyItemModel
class DMyMoneyItemResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DMyMoneyItemModel] = []
    
    class func parse(dict : Any ) -> DMyMoneyItemResponseModel{
        let model = DMyMoneyItemResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DMyMoneyItemModel.self]
    }
}

class DMyMoneyItemModel: NSObject {
    
    @objc var project_type = ""
    @objc var user_name = ""
    @objc var address = ""
    @objc var reward = ""
    @objc var create_time = ""
    @objc var checked = ""
}

