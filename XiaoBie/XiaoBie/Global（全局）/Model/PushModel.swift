//
//  PushModel.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2018/1/17.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - PushModel
class PushModel: NSObject,YYModel {

    @objc var order_id = ""
    @objc var response_type = ""
    @objc var push_type = ""
    @objc var type = ""

    class func parse(dict : Any ) -> PushModel{
        let model = PushModel.yy_model(withJSON: dict)
        return model!
    }
}

//MARK: - LockedOrderModel
class LockedOrderResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var result = ""
    @objc var msg = ""
    @objc var data = [LockedOrderModel]()
    
    class func parse(dict : Any ) -> LockedOrderResponseModel{
        let model = LockedOrderResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":LockedOrderModel.self]
    }
}

class LockedOrderModel: NSObject {
    
    @objc var id = ""
    @objc var status = ""
    @objc var project_type = ""
}
