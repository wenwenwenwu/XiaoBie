//
//  AvatarPickerTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class AvatarPickerTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - FactoryMethod
    class func toolWith(ownerViewController: UIViewController, completeClosure: @escaping (String,String)->Void) -> AvatarPickerTool {
        let tool = AvatarPickerTool()
        tool.ownerViewController = ownerViewController
        tool.completeClosure = completeClosure
        return tool
    }
    
    //MARK: - Event Response
    func openCamera(){
        var sourceType = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false//设置可编辑
        picker.sourceType = sourceType
        ownerViewController.present(picker, animated: true, completion: nil)//进入照相界面
        
    }
    
    func openAlbum(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = false
        ownerViewController.present(pickerImage, animated: true, completion: nil)
        
    }
    
    //MARK: - Request
    func upLoadAvatarRequest(imageLocalURL: URL) {
        WebTool.upLoadAvatar(imageURL: imageLocalURL, success: { (dict) in
            let model = AvatarResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.completeClosure(model.data,imageLocalURL.absoluteString)
            } else{
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //缓存图片并获取url
        let imageLocalURL = CacheTool.imageUrl(image: pickedImage)
        //上传图片
        upLoadAvatarRequest(imageLocalURL: imageLocalURL)
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Properties
    var ownerViewController = UIViewController()
    var completeClosure:(String,String)->Void = { imageName,localURL in }
    
}

//MARK: - PicturesModel
class AvatarResponseModel: NSObject {
    
    @objc var msg = ""
    @objc var result = ""
    @objc var code = ""
    @objc var data = ""
    
    class func parse(dict : Any ) -> AvatarResponseModel{
        let model = AvatarResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
