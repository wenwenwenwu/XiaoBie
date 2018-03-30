//
//  CToTestifyViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CToTestifyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = chatButtonItem
        view.addSubview(tableView)
        view.addSubview(whiteView)
        whiteView.addSubview(cancelButton)
        whiteView.addSubview(grayLine1)
        whiteView.addSubview(addButton)
        whiteView.addSubview(grayLine2)
        whiteView.addSubview(passButton)
        
        navigationItem.title = "待验单"
        view.backgroundColor = white_FFFFFF
        setupFrame()
        setupNavigationBar()
        codeListRequest()
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    @objc func backButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    func codeCellSendButtonAction() {
        remindRequest()
    }
    
    @objc func passButtonAction() {
        passRequest(passType: "0")
    }
    
    @objc func addButtonAction() {
        passRequest(passType: "1")
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
    
    //MARK: - Action Method
    func refreshCode() {
        pushCodeListRequest()
    }
    
    //MARK: - Request
    func setAccessStatusRequest() {
        WebTool.post(uri:"resp_verify_pop_win", para:["oper_type": "2", "staff_id": AccountTool.userInfo().id, "order_id": model.id], success: { (dict) in
            
        }) { (error) in
        }
    }
    
    func codeListRequest() {
        WebTool.get(uri:"list_verify_code", para:["order_id":model.id], success: { (dict) in
            let model = DCodeListResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.codeListArray = model.data
                self.tableView.reloadData()
            } else {
                
            }
        }) { (error) in
            
        }
    }
    
    func pushCodeListRequest() {
        WebTool.get(uri:"list_verify_code", para:["order_id":model.id], success: { (dict) in
            let model = DCodeListResponseModel.parse(dict: dict)
            if model.code == "0" {
                //刷新codeList
                self.codeListArray = model.data
                self.tableView.reloadData()
                //刷新codeCell
                let codeCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! CToTestifyCodeCell
                if let code = model.data.first?.code {
                    codeCell.code = code
                }
                
            } else {
                
            }
        }) { (error) in
            
        }
    }
    
    func cancelRequest(cancelReason: String) {
        WebTool.post(isShowHud: false, uri:"cancel_order", para:["staff_id": AccountTool.userInfo().id, "order_id":model.id, "remark": cancelReason], success: { (dict) in
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
        WebTool.post(uri: "notify_send_verify_code", para: ["order_id": model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func passRequest(passType: String) {
        WebTool.post(uri: "pass_order_vefiry", para: ["verify_type": passType, "order_id": model.id], success: { (dict) in
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return codeListArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let infoCell = CToTestifyInfoCell.cellWith(tableView: tableView)
            infoCell.model = model
            return infoCell
        case 1:
            let codeCell = CToTestifyCodeCell.cellWith(tableView: tableView)
            codeCell.sendButtonClosure = { [weak self] in
                self?.codeCellSendButtonAction()
            }
            return codeCell
        default:
            let codeCell = DCodeCodeCell.cellWith(tableView: tableView)
            codeCell.model = codeListArray[indexPath.row]
            return codeCell
        }
    }
    
    //MARK: - UITableViewDelegate
    //变化的sectionHeight要在代理中采用四种方法组合设置才有效，tableView中设置没有用
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let sectionHeader = DCodeSectionHeaderCell.cellWith(tableView: tableView)
            return sectionHeader
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 10
        default:
            return 0.1
        }
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
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(grayLine1.snp.left)
        }
        
        grayLine1.snp.makeConstraints { (make) in
            make.left.equalTo(screenWidth / 3)
            make.width.equalTo(1)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(grayLine1.snp.right)
            make.right.equalTo(grayLine2.snp.left)
        }
        
        grayLine2.snp.makeConstraints { (make) in
            make.left.equalTo(screenWidth * 2 / 3)
            make.width.equalTo(1)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        
        passButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(grayLine2.snp.right)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_return").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonAction))
    }
    
    //MARK: - Properties
    lazy var chatButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        return barButtonItem
    }()
    
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
        button.setTitle("取消", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("添加营销案", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var passButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("通过验证", for: .normal)
        button.setTitleColor(blue_3899F7, for: .normal)
        button.addTarget(self, action: #selector(passButtonAction), for: .touchUpInside)
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
    var codeListArray: [DCodeItemModel] = []
}

