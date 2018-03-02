//
//  SetListModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DToCheckClerkModel
class DSetListResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DSetItemModel] = []
    
    class func parse(dict : Any ) -> DSetListResponseModel{
        let model = DSetListResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DSetItemModel.self]
    }
}

class DSetItemModel: NSObject {

    @objc var id = ""
    @objc var business_type = ""
    @objc var plan_name = ""
    @objc var price = ""
    @objc var create_time = ""
    @objc var update_time = ""
}
