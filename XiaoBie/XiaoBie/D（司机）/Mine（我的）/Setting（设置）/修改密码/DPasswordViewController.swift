//
//  DPasswordViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/4/3.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DPasswordViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(oldCell)
        view.addSubview(newCell)
        view.addSubview(new2Cell)
        view.addSubview(confirmButton)
        
        view.backgroundColor = white_FFFFFF
        navigationItem.title = "修改密码"
        setupFrame()
    }
    
    //MARK: - Setup
    func setupFrame() {
        oldCell.snp.makeConstraints { (make) in
            make.top.equalTo(35)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
        }
        
        newCell.snp.makeConstraints { (make) in
            make.top.equalTo(oldCell.snp.bottom).offset(35)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
        }
        
        new2Cell.snp.makeConstraints { (make) in
            make.top.equalTo(newCell.snp.bottom).offset(35)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(new2Cell.snp.bottom).offset(35)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - Event Response
    @objc func confirmButtonAction() {
        guard !oldCell.textField.text!.isEmpty  else {
            HudTool.showInfo(string: "旧密码不能为空")
            return
        }
        
        guard !newCell.textField.text!.isEmpty  else {
            HudTool.showInfo(string: "新密码不能为空")
            return
        }
        
        guard newCell.textField.text == new2Cell.textField.text else {
            HudTool.showInfo(string: "两次输入的新密码不一致")
            return
        }
        
        changeRequest()
    }
    
    //MARK: - Request
    func changeRequest() {
        WebTool.post(uri: "update_password", para: ["new_pass": newCell.textField.text!, "staff_id": AccountTool.userInfo().id, "old_pass": oldCell.textField.text!], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.resignKeyBoardInView(view: self.view)
                HudTool.showInfo(string: model.msg)
                self.navigationController?.popViewController(animated: true)
            }else{
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Lazyload
    lazy var oldCell = LoginCell.cellWith(type: .oldPassword)
    
    lazy var newCell = LoginCell.cellWith(type: .newPassword)
    
    lazy var new2Cell = LoginCell.cellWith(type: .new2Password)
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font16
        button.setTitle("确认", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()

}
