//
//  AlibiModel.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

//MARK: - DAlibiModel
class DAlibiResponseModel: NSObject,YYModel {
    
    @objc var code = ""
    @objc var msg = ""
    @objc var result = ""
    @objc var data: [DAlibiModel] = []
    
    class func parse(dict : Any ) -> DAlibiResponseModel{
        let model = DAlibiResponseModel.yy_model(withJSON: dict)
        return model!
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["data":DAlibiModel.self]
    }
}

class DAlibiModel: NSObject {
    @objc var id = ""
    @objc var staff_id = ""
    @objc var image_names = "" {
        didSet{
            var imageArray: [String] = []
            let originalArray = image_names.components(separatedBy: ",")
            for item in originalArray {
                let imageURL = "\(imagesDownloadURL)\(item)"
                imageArray.append(imageURL)
            }
            self.imageArray = imageArray
        }
    }
    @objc var create_time = ""
    //自定义
    @objc var imageArray: [String] = []
}
