//
//  HomeSelectView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/7.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum DClockinType {
    case clockin
    case clockout
}

class DClockinViewHandler: NSObject, AMapLocationManagerDelegate {
    
    //MARK: - Factory Method
    class func handlerWith(ownerController: UIViewController) -> DClockinViewHandler {
        let handler = DClockinViewHandler()
        handler.ownerController = ownerController
        handler.clockinView = DClockinView.viewWith(ownerController: ownerController, clockinButtonClosure: {
            handler.currentType = .clockin
            handler.photoPickerTool.openCamera()
        }, clockoutButtonClosure: {
            handler.currentType = .clockout
            handler.photoPickerTool.openCamera()
        })
        return handler
    }
    
    //MARK: - Private Method
    func handle(forceDismiss: Bool) {
        if forceDismiss {
            if clockinView.isShow {
                clockinView.dismiss()
            }
        } else {
            if clockinView.isShow {
                clockinView.dismiss()
            } else {
                clockinView.show()
            }
        }        
    }
    
    //MARK: - Request
    func clockinRequest(location: CLLocation) {
        let telephone = AccountTool.userInfo().phone
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let signupType = (currentType == .clockin) ? "0" : "1"
        
        WebTool.post(uri: "staff_sign", para: ["img_name" : imageName, "telephone" : telephone, "sign_up_type" : signupType, "latitude" : latitude, "longitude": longitude ], success: { (dict) in
            let model = DHomeClockinResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Properties
    lazy var ownerController = UIViewController()
    
    lazy var clockinView = DClockinView()
    
    lazy var photoPickerTool = PhotoPickerTool.toolWith(uploadPara: "upload_sign_img", ownerViewController: ownerController) { (imageName, localUrl) in
        self.imageName = imageName
        self.locationTool.startUpdatingLocation()
    }
    lazy var locationTool = LocationTool.toolWith { [weak self] (location) in
        self?.clockinRequest(location: location)
    }
    
    var currentType: DClockinType = .clockin    
    var imageName = ""
}



