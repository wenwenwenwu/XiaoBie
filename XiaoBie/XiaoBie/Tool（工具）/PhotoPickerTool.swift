//
//  PhotoPickerTool.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/12/27.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

class PhotoPickerTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - FactoryMethod
    class func toolWith(uploadPara: String, ownerViewController: UIViewController, completeClosure: @escaping (String,String)->Void) -> PhotoPickerTool {
        let photoPickerTool = PhotoPickerTool()
        photoPickerTool.uploadPara = uploadPara
        photoPickerTool.ownerViewController = ownerViewController
        photoPickerTool.completeClosure = completeClosure
        return photoPickerTool
        
    }
    
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
    
    //UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //缓存图片并获取url
        let localURL = CacheTool.imageUrl(image: pickedImage)
        //传图片
        WebTool.upLoadImages( para: uploadPara, imageURLs: [localURL], success: { (dict) in
            let model = PicturesResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.completeClosure(model.data[0],localURL.absoluteString)
            } else{
                HudTool.showInfo(string: model.msg)
            }
        }, failture: { (error) in
            HudTool.showInfo(string: error)
        })
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Properties
    var completeClosure:(String,String)->Void = { imageName,localURL in }
    var ownerViewController = UIViewController()
    var uploadPara = ""
    
}

//MARK: - PicturesModel
class PicturesResponseModel: NSObject {
    
    @objc var msg = ""
    @objc var result = ""
    @objc var code = ""
    @objc var data: [String] = []
    
    class func parse(dict : Any ) -> PicturesResponseModel{
        let model = PicturesResponseModel.yy_model(withJSON: dict)
        return model!
    }
}
