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
    
    class func strDateToStrMDHM(strDate: String)-> String {
        guard !strDate.isEmpty else { return "" }
        let date = formatterFull.date(from: strDate)
        let calendar = Calendar.current
        let month = calendar.component(Calendar.Component.month, from: date!)
        let day = calendar.component(Calendar.Component.day, from: date!)
        let hour = calendar.component(Calendar.Component.hour, from: date!)
        let minute = calendar.component(Calendar.Component.minute, from: date!)
        let strMDHM = "\(processTime(time: month))-\(processTime(time: day)) \(processTime(time: hour)): \(processTime(time: minute))"
        return strMDHM
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
    
    class func str今天() -> (String) {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: now)
        let month = calendar.component(Calendar.Component.month, from: now)
        let day = calendar.component(Calendar.Component.day, from: now)
        let strDate = "\(year)-\(processTime(time: month))-\(processTime(time: day))"
        return (strDate)
    }
    
    class func str本月一号() -> (String) {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: now)
        let month = calendar.component(Calendar.Component.month, from: now)
        let strDate = "\(year)-\(processTime(time: month))-\(processTime(time: 1))"
        return (strDate)
    }
    
    //MARK: - dateToStr
    class func dateToStrDate(date: Date) -> String {
        let dateStr = formatter.string(from: date)
        return dateStr
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
    
    static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}


