//
//  Web.swift
//  PostOfficeAdmain
//
//  Created by wuwenwen on 2017/8/25.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import Foundation
import Alamofire

class WebTool {
    
    static let baseURL = "http://116.62.206.174:8080/longwang/general/"
//    static let imagesUploadURL = "http://manage.cloudconfs.com:8080/longwang/oss/upload_sign_img"
    static let imagesUploadURL = "http://manage.cloudconfs.com:8080/longwang/oss/"

    //POST
    class func post(isShowHud: Bool = true, uri: String ,para : [String:String],success :@escaping (_ response : NSDictionary)->(),failture : @escaping (_ error : String)->()){
        if isShowHud {
            HudTool.show()
        }
        Alamofire.request(baseURL+uri, method: HTTPMethod.post, parameters: para).responseJSON { (response) in
            if isShowHud {
                HudTool.dismiss()
            }
            switch response.result {
            case .success:
                if let jsonData = response.data{
                    do{
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        success(dict as! NSDictionary)
                    }catch {
                        failture("数据错误")
                    }
                }else{
                    failture("数据错误")
                }
            case .failure:
                failture("网络错误")
            }
        }
    }
    
    //GET
    class func get(isShowHud: Bool = true, uri:String, para : [String:String],success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : String)->()){
        if isShowHud {
            HudTool.show()
        }
        Alamofire.request(baseURL+uri, method: HTTPMethod.get, parameters: para).responseJSON { (response) in
            if isShowHud {
                HudTool.dismiss()
            }
            switch response.result {
            case .success:
                if let jsonData = response.data{
                    do{
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        success(dict as! NSDictionary)
                    }catch {
                        failture("数据错误")
                    }
                }else{
                    failture("数据错误")
                }
            case .failure:
                failture("网络错误")
            }
        }
    }

    //多张图片上传
    class func upLoadImages(para: String, imageURLs : [URL], success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : String)->()){
        HudTool.show()
        
        Alamofire.upload(
            //Closure参数
            multipartFormData: { multipartFormData in 
                for i in 0..<imageURLs.count {
                    multipartFormData.append(imageURLs[i], withName: "UPLOAD_IMAGES[]", fileName: "\(i).jpg", mimeType: "image/png")
                }
            //String参数
        }, to: imagesUploadURL+para
            //Closure参数
            , encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        HudTool.dismiss()
                        
                        if let jsonData = response.data{
                            do{
                                let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                                success(dict as! NSDictionary)
                            }catch {
                                failture("数据错误")
                            }
                        }else{
                            failture("数据错误")
                        }
                    }
                case .failure:
                    failture("网络错误")
                }
        })
        
    }

}

