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
    static let imageUploadURL = ""
    static let imagesUploadURL = ""
    static let verifyCodeURL = ""

    //POST
    class func post(isShowHud: Bool = true, uri: String ,para : [String:String],success :@escaping (_ response : NSDictionary)->(),failture : @escaping (_ error : Error)->()){
        if isShowHud {
            hudManager.show()
        }
        Alamofire.request(baseURL+uri, method: HTTPMethod.post, parameters: para).responseJSON { (response) in
            if isShowHud {
                hudManager.dismiss()
            }
            switch response.result {
            case .success:
                if let jsonData = response.data{
                    do{
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        success(dict as! NSDictionary)
                    }
                    catch let error  {
                        failture(error)
                    }
                }else{
                    let error = NSError(domain: "数据错误", code: 100, userInfo: nil)
                    failture(error)
                }
            case .failure:
                let error = NSError(domain: "网络错误", code: 100, userInfo: nil)
                failture(error)
            }
        }
    }
    //GET
    class func get(isShowHud: Bool = true, uri:String, para : [String:String],success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : Error)->()){
        if isShowHud {
            hudManager.show()
        }
        Alamofire.request(baseURL+uri, method: HTTPMethod.get, parameters: para).responseJSON { (response) in
            if isShowHud {
                hudManager.dismiss()
            }
            switch response.result {
            case .success:
                if let jsonData = response.data{
                    do{
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        success(dict as! NSDictionary)
                    }
                    catch let error  {
                        failture(error)
                    }
                }else{
                    let error = NSError(domain: "数据错误", code: 100, userInfo: nil)
                    failture(error)
                }
            case .failure:
                let error = NSError(domain: "网络错误", code: 100, userInfo: nil)
                failture(error)
            }
            
        }
    }
    //发送验证码
    class func getVerifyCode(phoneUri:String, para : [String:String],success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : Error)->()){
        hudManager.show()
        Alamofire.request(verifyCodeURL+phoneUri, method: HTTPMethod.get, parameters: para).responseJSON { (response) in
            hudManager.dismiss()
            switch response.result {
            case .success:
                if let jsonData = response.data{
                    do{
                        let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        success(dict as! NSDictionary)
                    }
                    catch let error  {
                        failture(error)                        
                    }
                }else{
                    let error = NSError(domain: "数据错误", code: 100, userInfo: nil)
                    failture(error)
                }                
            case .failure:
                let error = NSError(domain: "网络错误", code: 100, userInfo: nil)
                failture(error)
            }
        }
    }
    //单张图片上传
    class func upLoadImage(imageURLs : [URL], success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : Error)->()){
        hudManager.show()
        Alamofire.upload(
            //Closure参数
            multipartFormData: { multipartFormData in
            for i in 0..<imageURLs.count {
                multipartFormData.append(imageURLs[i], withName: "UPLOAD_IMAGE", fileName: "avatar.jpg", mimeType: "image/png")
            }
            //String参数
        }, to: imageUploadURL
            //Closure参数
         , encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    hudManager.dismiss()
                    
                    if let jsonData = response.data{
                        do{
                            let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                            success(dict as! NSDictionary)
                        }
                        catch let error  {
                            failture(error)                            
                        }
                    }else{
                        let error = NSError(domain: "数据错误", code: 100, userInfo: nil)
                        failture(error)
                    }
                }
            case .failure:
                let error = NSError(domain: "网络错误", code: 100, userInfo: nil)
                failture(error)
            }
        })
        
      }
    //多张图片上传
    class func upLoadImages(imageURLs : [URL], success : @escaping (_ response : NSDictionary)->(), failture : @escaping (_ error : Error)->()){
        hudManager.show()
        
        Alamofire.upload(
            //Closure参数
            multipartFormData: { multipartFormData in 
                for i in 0..<imageURLs.count {
                    multipartFormData.append(imageURLs[i], withName: "UPLOAD_IMAGES[]", fileName: "\(i).jpg", mimeType: "image/png")
                }
            //String参数
        }, to: imagesUploadURL
            //Closure参数
            , encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        hudManager.dismiss()
                        
                        if let jsonData = response.data{
                            do{
                                let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                                success(dict as! NSDictionary)
                            }
                            catch let error  {
                                failture(error)
                            }
                        }else{
                            let error = NSError(domain: "数据错误", code: 100, userInfo: nil)
                            failture(error)
                        }
                    }
                case .failure:
                    let error = NSError(domain: "网络错误", code: 100, userInfo: nil)
                    failture(error)
                }
        })
        
    }

}

