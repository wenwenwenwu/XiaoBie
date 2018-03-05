//
//  PhoneNumberTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class PhoneNumberTool {

    class func secret(phoneNumber: String) -> String {
        let rangeFront3 = phoneNumber.startIndex...phoneNumber.index(phoneNumber.startIndex, offsetBy:2)
        let strFront3 = phoneNumber[rangeFront3]
        return "\(strFront3)********"
    }
}
