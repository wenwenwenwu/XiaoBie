//
//  HomeModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class HomeResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var message = ""
    @objc var result = ""
    @objc var data: [GrabModel] = []
    
    class func parse(dict : Any ) -> HomeResponseModel{
        let model = HomeResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":GrabModel.self]
    }
}

