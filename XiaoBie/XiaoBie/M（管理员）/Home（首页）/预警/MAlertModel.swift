//
//  MAlertModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class MAlertListResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = [MAlertItemModel]()
    
    class func parse(dict : Any ) -> MAlertListResponseModel{
        let model = MAlertListResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":MAlertItemModel.self]
    }
}

class MAlertItemModel: NSObject {
    
    @objc var agent_id = ""
    @objc var threshold_count = ""
    @objc var done1_count = ""
    @objc var done2_count = ""
    @objc var done3_count = ""
}
