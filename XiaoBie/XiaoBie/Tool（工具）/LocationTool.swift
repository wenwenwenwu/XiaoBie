//
//  LocationTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/7.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit


class LocationTool: NSObject, AMapLocationManagerDelegate {
    
    //MARK: - Factory Method
    class func toolWith(resultClosure: @escaping (String,String)->Void) -> LocationTool {
        let tool = LocationTool()
        tool.resultClosure = resultClosure
        return tool
    }
    
    //MARK: - Action Method
    class func regist() {
        AMapServices.shared().apiKey = gaoDeAppKey
        AMapServices.shared().enableHTTPS = true
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    //MARK: AMapLocationManagerDelegate
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        locationManager.stopUpdatingLocation()
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        resultClosure(latitude, longitude)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        locationManager.stopUpdatingLocation()
        resultClosure("0", "0")
    }
    
    //MARK: - Properties
    lazy var locationManager: AMapLocationManager = {
        let locationManager = AMapLocationManager()
        locationManager.delegate = self as AMapLocationManagerDelegate
        locationManager.allowsBackgroundLocationUpdates = true
        return locationManager
    }()
    
    var resultClosure: (String, String)->Void = { _,_ in }
}
