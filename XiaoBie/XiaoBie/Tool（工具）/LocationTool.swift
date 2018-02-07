//
//  LocationTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/7.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class LocationTool {
    //保存
    class func saveLocation(lng:Double,lat:Double) {
        let currentLocation = ["lng":lng,"lat":lat]
        UserDefaults.standard.set(currentLocation, forKey: "currentLocation")
        UserDefaults.standard.synchronize()
    }
    //获得
    class func location() -> (lng:Double,lat:Double){
        let currentLocation = UserDefaults.standard.dictionary(forKey: "currentLocation")
        var lng:Double
        if (currentLocation?["lng"]) != nil {
            lng = currentLocation!["lng"] as! Double
        }else {
            lng = 0
        }
        var lat:Double
        if (currentLocation?["lat"]) != nil {
            lat = currentLocation!["lat"] as! Double
        }else {
            lat = 0
        }
        
        return (lng,lat)
    }
}
