//
//  LocationTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/7.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit


class LocationTool: NSObject, AMapLocationManagerDelegate {
    
    var resultClosure: (CLLocation)->Void = {_ in }
    
    lazy var locationManager: AMapLocationManager = {
        let locationManager = AMapLocationManager()
        locationManager.delegate = self as AMapLocationManagerDelegate
        return locationManager
    }()
    
    //MARK: - Factory Method
    class func toolWith(resultClosure: @escaping (CLLocation)->Void) -> LocationTool {
        let tool = LocationTool()
        tool.resultClosure = resultClosure
        return tool
    }
    
    //MARK: - Private Method
    class func regist() {
        AMapServices.shared().apiKey = gaodeAPIKey
        AMapServices.shared().enableHTTPS = true
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    //MARK: AMapLocationManagerDelegate
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        locationManager.stopUpdatingLocation()
        resultClosure(location)        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        locationManager.stopUpdatingLocation()
        resultClosure(CLLocation.init(latitude: 0, longitude: 0))
    }
    
}

//MARK: - 位置缓存
extension LocationTool {
    
    //路径
    static let locationPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/location.data"
    
    //获得
    class func location() -> CLLocation {
        if let location = NSKeyedUnarchiver.unarchiveObject(withFile: locationPath) as? CLLocation {
            return location
        }else {
            return CLLocation()
        }
    }
    
    //保存
    class func saveLocation(location: CLLocation) {
        NSKeyedArchiver.archiveRootObject(location, toFile: locationPath)

    }
}
