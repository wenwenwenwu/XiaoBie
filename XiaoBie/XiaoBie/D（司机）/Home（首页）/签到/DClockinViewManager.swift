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

class DClockinViewManager: NSObject, AMapLocationManagerDelegate {
    
    //MARK: - Factory Method
    class func managerWith(ownerController: UIViewController) -> DClockinViewManager {
        let manager = DClockinViewManager()
        manager.ownerController = ownerController
        manager.clockinView = DClockinView.viewWith(ownerController: ownerController, clockinButtonClosure: {
            manager.viewClockinButtonEvent()
        }, clockoutButtonClosure: {
            manager.viewClockoutButtonEvent()
        })
        return manager
    }
    
    //MARK: - Event Response
    func viewShowupEvent(forceDismiss: Bool) {
        if forceDismiss {
            if clockinView.isShow {
                clockinView.dismiss()
            }
        } else {
            if clockinView.isShow {
                clockinView.dismiss()
            } else {
                clockinStatusRequest()
            }
        }
    }
    
    func viewClockinButtonEvent() {
        currentType = .clockin
        photoPickerTool.openCamera()
    }
    
    func viewClockoutButtonEvent() {
        currentType = .clockout
        photoPickerTool.openCamera()
    }
    
    func photoPickerToolCompleteUploadEvent(imageName: String) {
        self.imageName = imageName
        locationTool.startUpdatingLocation()
    }
    
    func locationToolCompleteLocationEvent(latitude: String, longitude: String) {
        location = (latitude, longitude)
        clockinRequest()
    }
    
    //MARK: - Request
    func clockinStatusRequest() {
        WebTool.post(isShowHud: false, uri: "query_sign_status", para: ["staff_id":AccountTool.userInfo().id], success: { (dict) in
            let model = DHomeClockinStatusResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.model = model.data
                self.clockinView.show()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func clockinRequest() {
        let telephone = AccountTool.userInfo().phone
        let latitude = location.latitude
        let longitude = location.longitude
        let signupType = (currentType == .clockin) ? "0" : "1"
        
        WebTool.post(uri: "staff_sign", para: ["img_name" : imageName, "telephone" : telephone, "sign_up_type" : signupType, "latitude" : latitude, "longitude": longitude ], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Properties
    lazy var ownerController = UIViewController()
    
    lazy var clockinView = DClockinView()
    
    lazy var photoPickerTool = PhotoPickerTool.toolWith(uploadPara: "upload_sign_img", ownerViewController: ownerController) { (imageName, localUrl) in
        self.photoPickerToolCompleteUploadEvent(imageName: imageName)
    }
    
    var location: (latitude: String, longitude: String) = ("", "")
    lazy var locationTool = LocationTool.toolWith { (latitude, longitude) in
        self.locationToolCompleteLocationEvent(latitude: latitude, longitude: longitude)
    }
    
    var currentType: DClockinType = .clockin    
    var imageName = ""
    
    var model = DHomeClockinStatusModel() {
        didSet {
            clockinView.clockinButton.isEnabled = (model.up_status == "0")
            clockinView.clockoutButton.isEnabled = (model.down_status == "0")
        }
    }
    
}



