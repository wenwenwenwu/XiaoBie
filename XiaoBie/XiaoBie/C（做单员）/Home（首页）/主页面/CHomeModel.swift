//
//  CHomeModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/13.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class CHomeInfoResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = CHomeInfoModel()
    
    class func parse(dict : Any ) -> CHomeInfoResponseModel{
        let model = CHomeInfoResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":CHomeInfoModel.self]
    }
}

class CHomeInfoModel: NSObject {

    @objc var totay_count = ""
    @objc var month_count = ""
    @objc var payment = ""
    @objc var valuation = ""
    @objc var need_query_count = ""
    @objc var need_verify_count = ""
    @objc var completed_count = ""
    @objc var need_market_count = ""
}

