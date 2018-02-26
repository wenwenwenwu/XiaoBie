//
//  MyMoneyModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel
//MARK: - MyMoneyInfoModel
class MyMoneyInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = MyMoneyInfoModel()
    
    class func parse(dict : Any ) -> MyMoneyInfoResponseModel{
        let model = MyMoneyInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":MyMoneyInfoModel.self]
    }
}

class MyMoneyInfoModel: NSObject {
    @objc var total_pay_count = ""
    @objc var total_pay_money = ""
    @objc var today_pay_count = ""
    @objc var today_pay_money = ""
    @objc var punish_money = ""
}

