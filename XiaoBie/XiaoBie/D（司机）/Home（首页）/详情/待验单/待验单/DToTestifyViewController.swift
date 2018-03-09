//
//  DToTestifyViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DToTestifyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        remindButton.isEnabled = false
        view.addSubview(remindButton)
        setupNavigationBar()
        setupFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    //MARK: - Event Response
    @objc func transferButtonAction() {
        driverListRequest()
    }
    
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func remindButtonAction() {
        //输入验证码页面
        let codeVC = DCodeViewController()
        codeVC.model = model
        codeVC.serialNumber = serialNumber
        navigationController?.pushViewController(codeVC, animated: false)
        
//        //提醒验单
//        remindRequest()
    }
    
    func scanCellScanedAction() {
        clerkListRequest()
    }
    
    //MARK: - Request
    func driverListRequest() {
        WebTool.post(uri:"get_peer_staff_list", para:["staff_id": AccountTool.userInfo().id], success: { (dict) in
            let model = DDriverListResponseModel.parse(dict: dict)
            if model.code == "0" {
                let driverListVC = DDriverListViewController()
                driverListVC.dataArray = model.data
                driverListVC.model = self.model
                self.navigationController?.pushViewController(driverListVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func clerkListRequest() {
        WebTool.get(uri:"get_dealer_by_serialno", para:["business_type": model.project_type,  "serial_no":"ff873985", "order_id":model.id], success: { (dict) in
            let model = DToCheckClerkResponseModel.parse(dict: dict)
            if model.code == "0" {
                //设置提醒按钮
                self.remindButton.isEnabled = true
                //展示做单员列表
                self.clerkListArray = model.data
                self.tableView.reloadSections(IndexSet.init(integer: 2), with: .fade)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func remindRequest() {
        //跳转输入验证码
        let dCodeVC = DCodeViewController()
        dCodeVC.serialNumber = serialNumber
        dCodeVC.model = model
        navigationController?.pushViewController(dCodeVC, animated: false)
        
        
//        //提醒验证
//        WebTool.get(uri:"notify_verify_order", para:["verify_type":"0", "order_id": model.id, "dealer_id":currentClerk.id], success: { (dict) in
//            let model = DBasicResponseModel.parse(dict: dict)
//            HudTool.showInfo(string: model.msg)
//        }) { (error) in
//            HudTool.showInfo(string: error)
//        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return clerkListArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let infoCell = DToTestifyInfoCell.cellWith(tableView: tableView)
            infoCell.model = model
            return infoCell
        case 1:
            let scanCell = DToCheckScanCell.cellWith(tableView: tableView)
            scanCell.ownerController = self
            scanCell.scanedClosure = {[weak self] serialNumber in
                self?.serialNumber = serialNumber
                self?.scanCellScanedAction()
            }
            return scanCell
        default:
            let clerkCell = DToCheckClerkCell.cellWith(tableView: tableView)
            clerkCell.model = clerkListArray[indexPath.row]
            //首个选中
            if indexPath.row == 0 {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return clerkCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            //记录当前做单员
            currentClerk = clerkListArray[indexPath.row]
        }
    }
    //变化的sectionHeight要在代理中采用四种方法组合设置才有效，tableView中设置没有用
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "待验单"
        //transferButtonItem
        transferButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        transferButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        //chatButtonItem
        chatButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        chatButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        navigationItem.rightBarButtonItems = [transferButtonItem, chatButtonItem]
    }
    
    func setupFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 56, 0))
        }
        
        remindButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.bottom.equalTo(-10)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Properties
    lazy var transferButtonItem = UIBarButtonItem.init(title: "转单", style: .plain, target: self, action: #selector(transferButtonAction))
    lazy var chatButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var remindButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("提醒验单", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.setBackgroundImage(gray_CCCCCC.colorImage(), for: .disabled)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(remindButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel()
    var clerkListArray: [DToCheckClerkModel] = []
    var currentClerk = DToCheckClerkModel()
    var serialNumber = ""
    
}

