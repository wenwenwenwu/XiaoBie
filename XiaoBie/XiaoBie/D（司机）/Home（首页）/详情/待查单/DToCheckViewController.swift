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
        remindButton.isEnabled = false
        view.addSubview(remindButton)
        setupNavigationBar()
        setupFrame()
    }
    
    //MARK: - Event Response
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func remindButtonAction() {
        remindRequest()
    }
    
    //MARK: - Request
    func clerkListRequest(serialNumber: String) {
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
        navigationItem.title = "待查单"
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
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
    lazy var rightButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
    
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
        button.setTitle("提醒查单", for: .normal)
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
    
    var updatedAdressClosure: (DGrabItemModel)->Void = { _ in }    
}
