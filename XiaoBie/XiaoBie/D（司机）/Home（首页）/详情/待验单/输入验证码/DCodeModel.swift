//
//  DCodeModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DCodeItemModel
class DCodeListResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DCodeItemModel] = []
    
    class func parse(dict : Any ) -> DCodeListResponseModel{
        let model = DCodeListResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DCodeItemModel.self]
    }
}

class DCodeItemModel: NSObject {

    @objc var id = ""
    @objc var code = ""
    @objc var order_id = ""
    @objc var delivery_id = ""
    @objc var dealer_id = ""
    @objc var create_time = ""
}

