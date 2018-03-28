//
//  DToCheckViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/1.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToCheckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        view.addSubview(whiteView)
        whiteView.addSubview(cancelButton)
        whiteView.addSubview(lineView)
        remindButton.isEnabled = false
        whiteView.addSubview(remindButton)
        setupNavigationBar()
        setupFrame()
    }
    
    //MARK: - Event Response
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func cancelButtonAction() {
        Alert.showAlertWith(style: .alert, controller: self, title: "确定要取消订单吗", message: nil, functionButtons: ["确定"]) { _ in
            self.cancelRequest()
        }
    }
    
    @objc func remindButtonAction() {
        remindRequest()
    }
    
    //MARK: - Request
    func clerkListRequest(serialNumber: String) {
        WebTool.get(uri:"get_dealer_by_serialno", para:["business_type": model.project_type,  "serial_no": serialNumber, "order_id":model.id], success: { (dict) in
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
    
    func cancelRequest() {
        WebTool.post(isShowHud: false, uri:"cancel_order", para:["staff_id": AccountTool.userInfo().id, "order_id":model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func remindRequest() {
        WebTool.get(uri:"notify_query_order", para:["order_id": model.id,  "dealer_id":currentClerk.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
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
        case 1:
            return (model.statusType == .querying) ? 0 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let infoCell = DToCheckInfoCell.cellWith(tableView: tableView)
            infoCell.model = model
            infoCell.finishEditClosure = { [weak self] model in
                //刷新当前页面
                self?.model.address = model.address
                self?.model.distance = model.distance
                self?.tableView.reloadData()
                //刷新列表页面
                self?.updatedAdressClosure(model)
            }
            return infoCell
        case 1:
            let scanCell = DToCheckScanCell.cellWith(tableView: tableView)
            scanCell.ownerController = self
            scanCell.scanedClosure = {[weak self] serialNumber in
               self?.clerkListRequest(serialNumber: serialNumber)
            }
            return scanCell
        default:
            let clerkCell = DToCheckClerkCell.cellWith(tableView: tableView)
            clerkCell.model = clerkListArray[indexPath.row]
            //首个选中
            if indexPath.row == 0 {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                //记录首个做单员
                currentClerk = clerkListArray[0]
            }
            return clerkCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
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
        navigationItem.title = "待查单"
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
    }
    
    func setupFrame() {
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(whiteView.snp.top)
        }
        
        whiteView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(lineView.snp.left)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(screenWidth / 2)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(17)
        }
        
        remindButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(lineView.snp.right)
        }
    }
    
    //MARK: - Properties
    lazy var rightButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
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
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("客户取消", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var remindButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("提醒查单", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.setTitleColor(gray_999999, for: .disabled)
        button.addTarget(self, action: #selector(remindButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()

    var model = DGrabItemModel()
    var clerkListArray: [DToCheckClerkModel] = []
    var currentClerk = DToCheckClerkModel()
    
    var updatedAdressClosure: (DGrabItemModel)->Void = { _ in }    
}
