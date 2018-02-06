//
//  PhotoPickerHandler.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/12/27.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit
import YYModel

class PhotoPickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var completeClosure:(String,String)->Void = { URL,localURL in }
    var ownerViewController = UIViewController()
    
    //MARK: - Factory Method
    class func handlerWith(ownerViewController: UIViewController, completeClosure: @escaping (String,String)->Void) -> PhotoPickerHandler {
        let handler = PhotoPickerHandler()
        handler.ownerViewController = ownerViewController
        handler.completeClosure = completeClosure
        return handler
        
    }
    
    //MARK: - Private Method
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
    func uploadImage(localURL: URL) {
        webManager.upLoadImages( imageURLs: [localURL], success: { (dict) in
            let model = PicturesResponseModel.parse(dict: dict)
            if model.result == "success" {
                self.completeClosure(model.data.images,localURL.absoluteString)
            } else{
                hudManager.showInfo(string: model.msg)
            }
        }, failture: { (error) in
            hudManager.showNetErrorInfo()
        })
    }
    
    //UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //缓存图片并获取url
        let localURL = CacheTool.imageUrl(image: pickedImage)
        //上传图片
        uploadImage(localURL: localURL)
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - PicturesModel
class PicturesResponseModel: NSObject {
    
    @objc var msg = ""
    @objc var result = ""
    @objc var data = PicturesModel()
    
    class func parse(dict : Any ) -> PicturesResponseModel{
        let model = PicturesResponseModel.yy_model(withJSON: dict)
        return model!
    }
}

class PicturesModel: NSObject {
    @objc var images = ""
}
