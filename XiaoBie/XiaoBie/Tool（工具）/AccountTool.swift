//
//  AccountToolViewController.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/23.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import Foundation
import YYModel

class AccountTool {
    
    //路径
    static let userInfoPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/userInfo.data"
    
    //获得
    class func userInfo() -> UserInfoModel {
        if let userInfoModel = NSKeyedUnarchiver.unarchiveObject(withFile: userInfoPath) as? UserInfoModel {
            return userInfoModel
        }else {
            return UserInfoModel()
        }
    }
    
    //登录(账户信息存本地)
    class func signIn(with userInfoModel:UserInfoModel) {
        NSKeyedArchiver.archiveRootObject(userInfoModel, toFile: userInfoPath)

    }
    
    //登出(删除账户信息)
    class func signOut() {
        let fileManager = FileManager()
        try?fileManager.removeItem(atPath: userInfoPath)
        
    }
    
    //是否登录
    class func isSignIn() -> Bool {
        if !AccountTool.userInfo().id.isEmpty {
            return true
        }else {
            return false
        }
    }
}

class UserInfoModel: NSObject, NSCoding,YYModel {
    
        @objc var agent_id = ""
        @objc var business_type = ""
        @objc var create_time = ""
        @objc var id = ""
        @objc var name = ""
        @objc var password = ""
        @objc var phone = ""
        @objc var role = ""
        @objc var role_level = ""
        @objc var update_time = ""

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
}

