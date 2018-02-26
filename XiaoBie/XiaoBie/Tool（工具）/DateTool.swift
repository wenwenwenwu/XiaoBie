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
    
    class func strDateToStr年月日(strDate: String)-> String {
        guard !strDate.isEmpty else { return "" }
        let date = formatterFull.date(from: strDate)
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: date!)
        let month = calendar.component(Calendar.Component.month, from: date!)
        let day = calendar.component(Calendar.Component.day, from: date!)
        let str年月日 = "\(year)-\(processTime(time: month))-\(processTime(time: day))"
        return str年月日
    }
    
    class func 今天() -> (str年月日: String, str年月日时分秒: String, year: String, month: String, day: String) {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: now)
        let month = calendar.component(Calendar.Component.month, from: now)
        let day = calendar.component(Calendar.Component.day, from: now)
        
        let str年月日 = "\(year)-\(processTime(time: month))-\(processTime(time: day))"
        let str年月日时分秒 = "\(year)-\(processTime(time: month))-\(processTime(time: day)) 23:59:59"
        return (str年月日, str年月日时分秒,"\(year)", "\(month)" ,"\(day)")
    }
    
    class func 本月一号() -> (str年月日: String, str年月日时分秒: String, year: String, month: String, day: String) {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: now)
        let month = calendar.component(Calendar.Component.month, from: now)
        let str年月日 = "\(year)-\(processTime(time: month))-\(processTime(time: 1))"
        let str年月日时分秒 = "\(year)-\(processTime(time: month))-\(processTime(time: 1)) 00:00:01"
        return (str年月日, str年月日时分秒, "\(year)", "\(month)" ,"\(1)")
    }
    
    //把"2018-02-01 16:00:01"中的"0"改为"00"
    class func processTime(time: Int) -> String {
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


