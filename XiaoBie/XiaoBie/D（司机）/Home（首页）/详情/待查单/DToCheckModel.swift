//
//  DToCheckModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/1.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DToCheckClerkModel
class DToCheckClerkResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DToCheckClerkModel] = []
    
    class func parse(dict : Any ) -> DToCheckClerkResponseModel{
        let model = DToCheckClerkResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DToCheckClerkModel.self]
    }
}

class DToCheckClerkModel: NSObject {
    
    @objc var id = ""
    @objc var name = ""
    @objc var phone = ""
    @objc var avatar = ""
    @objc var role = ""
    @objc var role_level = ""
    @objc var business_type = ""
    @objc var agent_id = ""
    @objc var agent_name = ""
    @objc var create_time = ""
    @objc var update_time = ""
    @objc var password = ""
}

//MARK: - DToCheckUpdateAdressResponseModel
class DToCheckUpdateAdressResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = DGrabItemModel()
    
    class func parse(dict : Any ) -> DToCheckUpdateAdressResponseModel{
        let model = DToCheckUpdateAdressResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
