//
//  AccountToolViewController.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/23.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import Foundation
import YYModel

//单例
let accountManager = AccountTool.instanceManager
class AccountTool {
    //创建单例
    static let instanceManager : AccountTool = AccountTool()
    private init() { }
    
    //路径
    let userInfoPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/userInfo.data"
    
    //获得
    func userInfo() -> UserInfoModel {
        if let userInfoModel = NSKeyedUnarchiver.unarchiveObject(withFile: userInfoPath) as? UserInfoModel {
            return userInfoModel
        }else {
            return UserInfoModel()
        }
    }
    
    //登录(账户信息存本地)
    func signIn(with userInfoModel:UserInfoModel) {
        NSKeyedArchiver.archiveRootObject(userInfoModel, toFile: userInfoPath)

    }
    
    //登出(删除账户信息)
    func signOut() {
        let fileManager = FileManager()
        try?fileManager.removeItem(atPath: userInfoPath)
        
    }
    
    //判断登录
    func isSignIn() -> Bool {
        if accountManager.userInfo().userId != "0" {
            return true
        }else {
            return false
        }
    }
    
    //判断绑定
    func isBinding() -> Bool {
        if accountManager.userInfo().wechatId != "" {
            return true
        }else {
            return false
        }
    }
}

class UserInfoModel: NSObject, NSCoding,YYModel {
    
    @objc var userId = "0"
    @objc var name = ""
    @objc var nickName = ""
    @objc var telephone = ""
    @objc var account = ""
    @objc var parentId = ""
    @objc var gold = ""
    @objc var money = ""
    @objc var headpath = ""
    @objc var birthday = ""
    @objc var sex = ""
    @objc var myInvitation = ""
    @objc var isOnline = ""
    @objc var create_date = ""
    @objc var job = ""
    @objc var educational = ""
    @objc var last_visit_date = ""
    @objc var code = ""
    @objc var push_time_1 = ""
    @objc var push_time_2 = ""
    @objc var push_time_3 = ""
    @objc var push_time_4 = ""
    @objc var wechatId = ""
    @objc var password = ""
    @objc var is_first_login = ""

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

