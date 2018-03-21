//
//  MCompleteModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/21.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class MOrderDetailResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data = DGrabItemModel()
    
    class func parse(dict : Any ) -> MOrderDetailResponseModel{
        let model = MOrderDetailResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
