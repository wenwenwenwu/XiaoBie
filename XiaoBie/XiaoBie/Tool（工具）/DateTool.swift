//
//  DateTool.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/12/14.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

class DateTool {
    
    //MARK: - strToStr
    class func strDateToStr月日时分(strDate: String)-> String {
        guard !strDate.isEmpty else { return "" }
        let date = formatterFull.date(from: strDate)
        let calendar = Calendar.current
        let month = calendar.component(Calendar.Component.month, from: date!)
        let day = calendar.component(Calendar.Component.day, from: date!)
        let hour = calendar.component(Calendar.Component.hour, from: date!)
        let minute = calendar.component(Calendar.Component.minute, from: date!)
        let str月日时分 = "\(month)月\(day)日 \(processTime(time: hour)): \(processTime(time: minute))"
        return str月日时分
    }
    
    //把"2018-02-01 16:00:01"中的"0"改为"00"
    private class func processTime(time: Int) -> String {
        let finalTime = String.init(format: "%02d",time) //不足两位用0补
        return finalTime
    }
    
    //MARK: - Properties
    static let formatterFull:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()    
}


