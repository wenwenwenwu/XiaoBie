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
    
    //头像上传
    class func upLoadAvatar(imageURL: URL, success: @escaping (_ response: NSDictionary)->(), failture: @escaping (_ error : String)->()){
        HudTool.show()
        Alamofire.upload(
            //数据
            multipartFormData: { multipartFormData in
                //图片地址（name和fileName:给自己看的）
                multipartFormData.append(imageURL, withName: "UPLOAD_IMAGE", fileName: "image.jpg", mimeType: "image/jpg")
            //网址
        }, to: uploadURL + "upload_avatar"
            //回调
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
                    HudTool.dismiss()
                    failture("网络错误")
                }
        })
        
    }

    //照片上传(其中type、orderId为订单凭证图片专用)
    class func upLoadImage(para: String, type: String, orderId: String, imageURL: URL, success: @escaping (_ response: NSDictionary)->(), failture: @escaping (_ error : String)->()){
        HudTool.show()
        Alamofire.upload(
            //数据
            multipartFormData: { multipartFormData in
                //图片地址（name和fileName:给自己看的）
                multipartFormData.append(imageURL, withName: "UPLOAD_IMAGE", fileName: "image.jpg", mimeType: "image/jpg")
                //类型
                let typeData = type.data(using: String.Encoding.utf8)
                multipartFormData.append(typeData!, withName: "upload_type")
                //订单号
                let orderIdData = orderId.data(using: String.Encoding.utf8)
                multipartFormData.append(orderIdData!, withName: "order_id")
                //网址
        }, to: uploadURL+para
            //回调
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
                    HudTool.dismiss()
                    failture("网络错误")
                }
        })
        
    }
    
    //上传凭证之音频上传
    class func upLoadAudio(orderId: String, audioURL: URL, success: @escaping (_ response: NSDictionary)->(), failture: @escaping (_ error : String)->()){
        HudTool.show()
        Alamofire.upload(
            //数据
            multipartFormData: { multipartFormData in
                //音频地址（name和fileName:给自己看的）
                multipartFormData.append(audioURL, withName: "UPLOAD_AUDIO", fileName: "record.wav", mimeType: "application/octet-stream")
                //类型
                let typeData = "audio".data(using: String.Encoding.utf8)
                multipartFormData.append(typeData!, withName: "upload_type")
                //订单号
                let orderIdData = orderId.data(using: String.Encoding.utf8)
                multipartFormData.append(orderIdData!, withName: "order_id")
            //网址
        }, to: uploadURL+"upload_order_evidence"
            //回调
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
                    HudTool.dismiss()
                    failture("网络错误")
                }
        })
        
    }

}

