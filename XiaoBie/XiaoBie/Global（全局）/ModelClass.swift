//
//  ModelClass.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

import YYModel

class ModelClass: NSObject,YYModel {
    
    
    class func parse<T>(dict : Any ) -> ModelClass as T{
        let model = T.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":GrabModel.self]
    }
}
