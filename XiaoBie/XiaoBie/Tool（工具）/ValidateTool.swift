//
//  RegexTool.swift
//  PostOfficeAdmain
//
//  Created by wuwenwen on 2017/10/18.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import Foundation

class ValidateTool {
    
    enum ValidateType {
        case PhoneNumber //手机
        case IDCard //身份证
        case Password //6-20位字母数字密码
    }
    
    private class func validateText(validateType type: ValidateType, validateString: String) -> Bool {
        do {
            let pattern: String
            switch type {
            case .PhoneNumber:
                pattern = "^[1][3|4|5|7|8]+\\d{9}$"
            case .IDCard:
                pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
            default:
                pattern = "^[0-9A-Za-z]{6,20}$"
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    class func isPhoneNumber(vStr: String) -> Bool {
        return validateText(validateType: ValidateType.PhoneNumber, validateString: vStr)
    }
    
    class func isIDCard(vStr: String) -> Bool {
        return validateText(validateType: ValidateType.IDCard, validateString: vStr)
    }
    
    class func isPassword(vStr: String) -> Bool {
        return validateText(validateType: ValidateType.Password, validateString: vStr)
    }
}
