//
//  LoginViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
        view.addSubview(label)
        view.addSubview(telephoneCell)
        view.addSubview(passwordCell)
        view.addSubview(button)
        setupNavigationBar()
        setupFrame()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupFrame() {
        label.snp.makeConstraints { (make) in
            make.top.equalTo(67)
            make.left.equalTo(12)
        }
        
        telephoneCell.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(50)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
        }
        
        passwordCell.snp.makeConstraints { (make) in
            make.top.equalTo(telephoneCell.snp.bottom).offset(35)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(passwordCell.snp.bottom).offset(35)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - Event Response
    @objc func loginButtonAction() {
        guard !telephoneCell.textField.text!.isEmpty  else {
            HudTool.showInfo(string: "手机号不能为空")
            return
        }
        
        guard ValidateTool.isPhoneNumber(vStr: telephoneCell.textField.text!) else {
            HudTool.showInfo(string: "请输入正确的手机号")
            return
        }
        
        guard !passwordCell.textField.text!.isEmpty  else {
            HudTool.showInfo(string: "密码不能为空")
            return
        }
        
        guard ValidateTool.isPassword(vStr: passwordCell.textField.text!) else {
            HudTool.showInfo(string: "验证码为6-20位的字母数字")
            return
        }
        
        loginRequest()
    }
    
    //MARK: - Request
    func loginRequest() {
        let telephone = telephoneCell.textField.text!
        let password = passwordCell.textField.text!
        
        WebTool.post(uri: "staff_login", para: ["password" : password, "telephone" : telephone], success: { (dict) in
            let model = LoginResponseModel.parse(dict: dict)
            if model.code == "0" {
                //保存用户信息
                AccountTool.login(with: model.data[0])
                //退出当前键盘
                self.resignKeyBoardInView(view: self.view)
                //退出登录模块
                self.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Lazyload
    lazy var label: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "您好，请登录"
        label.textColor = black_333333
        label.font = font26Medium
        return label
    }()
    
    lazy var telephoneCell = LoginCell.cellWith(type: .phone)
    
    lazy var passwordCell = LoginCell.cellWith(type: .password)
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font16
        button.setTitle("登录", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
}
