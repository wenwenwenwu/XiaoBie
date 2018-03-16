//
//  MHistoryModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class MHistorySourceResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [MHistorySourceModel] = []
    
    class func parse(dict : Any ) -> MHistorySourceResponseModel{
        let model = MHistorySourceResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":MHistorySourceModel.self]
    }
}

class MHistorySourceModel: NSObject,YYModel {
    
    @objc var id = ""
    @objc var source_name = ""
    @objc var create_time = ""
    @objc var update_time = ""
}

