//
//  MHistoryModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class MHistoryPickParaResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [MHistoryPickParaModel] = []
    
    class func parse(dict : Any ) -> MHistoryPickParaResponseModel{
        let model = MHistoryPickParaResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":MHistoryPickParaModel.self]
    }
}

class MHistoryPickParaModel: NSObject,YYModel {
    
    @objc var id = ""
    @objc var model_id = ""
    @objc var source_id = ""
    @objc var param_type = ""
    @objc var create_time = ""
    @objc var update_time = ""
    @objc var param_name = ""//参数
    @objc var model_name = ""//名称
    @objc var source_name = ""//来源
}

