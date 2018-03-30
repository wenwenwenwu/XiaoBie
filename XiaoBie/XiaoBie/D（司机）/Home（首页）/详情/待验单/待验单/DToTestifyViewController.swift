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
        view.addSubview(cancelButton)
        view.addSubview(lineView)
        remindButton.isEnabled = false
        view.addSubview(remindButton)
        setupNavigationBar()
        setupFrame()
        //将当前控制器赋值给全局变量currentController，便于收到推送后操作
        currentController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        if isLocked {
            //隐藏导航控制器返回按钮
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = nil
        }
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
    
    @objc func cancelButtonAction() {
        let cancelVC = CancelViewController()
        cancelVC.confirmButtonClosure = {[unowned self] cancelReason in
            self.cancelVCConfirmButtonAction(cancelReason: cancelReason)
        }
        navigationController?.pushViewController(cancelVC, animated: true)
    }
    
    func cancelVCConfirmButtonAction(cancelReason: String) {
        cancelRequest(cancelReason: cancelReason)
    }
    
    @objc func remindButtonAction() {
        remindRequest()
    }
    
    func remindButtonChangeStatusAction(status: CountDownButtonStatus) {
        switch status {
        case .disabledCounting:
            isClerkChangeable = false
        case .disabled:
            isClerkChangeable = false
        case .enabled:
            isClerkChangeable = true
        }
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
    
    func cancelRequest(cancelReason: String) {
        WebTool.post(isShowHud: false, uri:"cancel_order", para:["staff_id": AccountTool.userInfo().id, "order_id":model.id, "remark": cancelReason], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                let homeVC = self.navigationController?.viewControllers[0] as! DHomeViewController
                //待预约页面更新
                let toOrderVC = homeVC.checkedVC
                toOrderVC.loadRequest()
                //跳转回首页主页面
                self.navigationController?.popToViewController(homeVC, animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func clerkListRequest() {
        WebTool.get(uri:"get_dealer_by_serialno", para:["business_type": model.project_type,  "serial_no": serialNumber, "order_id":model.id], success: { (dict) in
            let model = DToCheckClerkResponseModel.parse(dict: dict)
            if model.code == "0" {
                //展示做单员列表
                self.clerkListArray = model.data
                self.tableView.reloadSections(IndexSet.init(integer: 2), with: .fade)
                if !self.clerkListArray.isEmpty {
                    //设置做单员可选
                    self.isClerkChangeable = true
                    //设置提醒按钮
                    self.remindButton.isEnabled = true
                    //设置默认的currentClerkCell
                    self.currentClerkCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? DToCheckClerkCell
                }
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func remindRequest() {
        WebTool.get(uri:"notify_verify_order", para:["order_id": model.id,
                                                     "serial_no":serialNumber,
                                                     "dealer_id":currentClerkCell!.model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.remindButton.status = .disabledCounting
                //将当前控制器赋值给全局变量currentController，便于收到推送后操作
                currentController = self
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 2 && !isClerkChangeable {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            //记录当前做单员
            currentClerkCell = tableView.cellForRow(at: indexPath) as? DToCheckClerkCell
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
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 44, 0))
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.right.equalTo(lineView.snp.left)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.width.equalTo(1)
            make.height.equalTo(17)
        }
        
        remindButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(lineView.snp.right)
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
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("客户取消", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var remindButton: CountDownButton = {
        let button = CountDownButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("提醒验单", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.setTitleColor(gray_B3B3B3, for: .disabled)
        button.addTarget(self, action: #selector(remindButtonAction), for: .touchUpInside)
        button.changeStatusClosure = { [weak self] status in
            self?.remindButtonChangeStatusAction(status: status)
        }
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    var model = DGrabItemModel()
    var clerkListArray: [DToCheckClerkModel] = [] 
    var currentClerkCell: DToCheckClerkCell?
    
    var serialNumber = ""
    
    var isClerkChangeable = false
    
    var isLocked = false
    
}

