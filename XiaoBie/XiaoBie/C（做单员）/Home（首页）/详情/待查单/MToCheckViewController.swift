//
//  MToCheckViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MToCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "待查单"
        navigationItem.rightBarButtonItem = chatBarButtonItem
        view.addSubview(whiteView1)
        whiteView1.addSubview(nameKeyLabel)
        whiteView1.addSubview(nameValueLabel)
        whiteView1.addSubview(phoneKeyLabel)
        whiteView1.addSubview(phoneValueLabel)
        whiteView1.addSubview(setKeyLabel)
        whiteView1.addSubview(setValueLabel)
        view.addSubview(whiteView2)
        whiteView2.addSubview(liveButton)
        whiteView2.addSubview(grayLine1)
        whiteView2.addSubview(yesButton)
        whiteView2.addSubview(grayLine2)
        whiteView2.addSubview(noButton)
        view.backgroundColor = gray_F5F5F5
        setupFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func liveButtonAction() {
        print("现场验证")
    }
    
    @objc func yesButtonAction() {
        print("有此活动")
    }

    @objc func noButtonAction() {
        print("无此活动")
    }
    
    //MARK: - Setup
    func setupFrame() {
        whiteView1.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(96)
        }
        
        //key
        nameKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        phoneKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        setKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(setValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        //value
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(nameKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(12)
            make.left.equalTo(phoneKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        setValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(12)
            make.left.equalTo(setKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        whiteView2.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        grayLine1.snp.makeConstraints { (make) in
            make.left.equalTo(screenWidth / 3)
            make.width.equalTo(1)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        grayLine2.snp.makeConstraints { (make) in
            make.left.equalTo(screenWidth * 2 / 3)
            make.width.equalTo(1)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        liveButton.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.right.equalTo(grayLine1.snp.left)
        }
        
        yesButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(grayLine1.snp.right)
            make.right.equalTo(grayLine2.snp.left)
        }
        
        noButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(grayLine2.snp.right)
        }
        
    }
    
    //MARK: - Properties
    lazy var chatBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        return barButtonItem
    }()
    
    lazy var whiteView1: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var nameKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "客户姓名"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var nameValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var phoneKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "联系方式"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var phoneValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var setKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "套餐档位"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var setValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var whiteView2: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var liveButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("现场验证", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(liveButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var yesButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("有此活动", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(yesButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var noButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("无此活动", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(noButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var grayLine1: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    lazy var grayLine2: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    var model = DGrabItemModel() {
        didSet {
            nameValueLabel.text = model.user_name
            phoneValueLabel.text = model.phone1
            setValueLabel.text = model.gtcdw
        }
    }
    
}
