//
//  MLocationModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class MLocationListResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = [MLocationItemModel]()
    
    class func parse(dict : Any ) -> MLocationListResponseModel{
        let model = MLocationListResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":MLocationItemModel.self]
    }
}

class MLocationItemModel: NSObject {
    
    @objc var id = ""
    @objc var name = ""
    @objc var phone = ""
    @objc var avatar = ""
    @objc var role = ""
    @objc var role_level = ""
    @objc var business_type = ""
    @objc var agent_id = ""
    @objc var agent_name = ""
    @objc var lock_order_id = ""
    @objc var create_time = ""
    @objc var update_time = ""
    @objc var source_id = ""
    @objc var latitude = ""
    @objc var longitude = ""
    @objc var address = ""
    @objc var password = ""
    @objc var locate_time = ""
    @objc var image_host = ""
}

