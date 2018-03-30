//
//  CToCheckViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CToCheckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = chatButtonItem
        view.addSubview(tableView)
        view.addSubview(whiteView)
        whiteView.addSubview(liveButton)
        whiteView.addSubview(grayLine1)
        whiteView.addSubview(yesButton)
        whiteView.addSubview(grayLine2)
        whiteView.addSubview(noButton)
        
        navigationItem.title = "待查单"
        view.backgroundColor = white_FFFFFF
        setupFrame()
        //适配推送情况(无论哪个导航控制器推出，最终都回到首页)
        setupPopDestination()
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    @objc func chatButtonAction() {
        chatSessionRequest()
    }
    
    @objc func liveButtonAction() {
        checkOrderRequest(targetStatus: "10")
    }
    
    @objc func yesButtonAction() {
        checkOrderRequest(targetStatus: "3")
    }
    
    @objc func noButtonAction() {
        checkOrderRequest(targetStatus: "9")
    }
    
    //MARK: - Request
    func chatSessionRequest() {
        WebTool.post(uri: "get_groupid_by_staffid",para: ["staff_id": AccountTool.userInfo().id], success: { (dict) in
            let model = CChatSessionResponseModel.parse(dict: dict)
            if model.code == "0" {
                let session = NIMSession.init(model.data, type: NIMSessionType.init(rawValue: 1)!)                
                let vc = NIMSessionViewController.init(session: session)
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func checkOrderRequest(targetStatus: String) {
        WebTool.post(uri: "check_order_by_dealer",para: ["target_status": targetStatus,"order_id": model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = CToCheckInfoCell.cellWith(tableView: tableView)
        infoCell.model = model
        return infoCell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //MARK: - Setup
    func setupFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        whiteView.snp.makeConstraints { (make) in
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
    
    func setupPopDestination() {
        var controllerArray = navigationController?.viewControllers
        controllerArray = [(controllerArray?.first)!, (controllerArray?.last)!]
        navigationController?.setViewControllers(controllerArray!, animated: false)
    }
    
    //MARK: - Properties
    lazy var chatButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        return barButtonItem
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var whiteView: UIView = {
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
    
    var model = DGrabItemModel()
}
