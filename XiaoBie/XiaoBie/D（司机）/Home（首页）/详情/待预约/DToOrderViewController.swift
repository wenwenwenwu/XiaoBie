//
//  DToOrderViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(orderButton)
        view.addSubview(lineView)
        setupNavigationBar()
        setupFrame()
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    @objc func changeButtonAction() {
        print("转单")
    }
    
    @objc func cancelButtonAction() {
        cancelRequest()
    }
    
    @objc func orderButtonAction() {
        remindRequest()
    }
    
    //MARK: - Request
    func cancelRequest() {
        
    }
    func setListRequest() {
//        WebTool.get(uri:"get_dealer_by_serialno", para:["business_type": model.project_type,  "serial_no":"ff873985", "order_id":model.id], success: { (dict) in
//            let model = DToCheckClerkResponseModel.parse(dict: dict)
//            if model.code == "0" {
//                //设置提醒按钮
//                self.remindButton.isEnabled = true
//                //展示做单员列表
//                self.clerkListArray = model.data
//                self.tableView.reloadSections(IndexSet.init(integer: 2), with: .fade)
//            } else {
//                HudTool.showInfo(string: model.msg)
//            }
//        }) { (error) in
//            HudTool.showInfo(string: error)
//        }
    }
    
    func remindRequest() {
//        WebTool.get(uri:"notify_query_order", para:["order_id": model.id,  "dealer_id":currentClerk.id], success: { (dict) in
//            let model = DBasicResponseModel.parse(dict: dict)
//            HudTool.showInfo(string: model.msg)
//        }) { (error) in
//            HudTool.showInfo(string: error)
//        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let infoCell = DToOrderInfoCell.cellWith(tableView: tableView)
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
        default:
            let setPickCell = DToOrderSetPickCell.cellWith(tableView: tableView)
            return setPickCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            print("选择套餐")
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
        navigationItem.title = "待预约"
        navigationItem.rightBarButtonItem = rightButtonItem
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
        
        orderButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(lineView.snp.right)
        }
    }
    
    //MARK: - Properties
    lazy var rightButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_zd").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(changeButtonAction))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.bounces = false
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
    
    lazy var orderButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("客户预约", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.addTarget(self, action: #selector(orderButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    var model = DGrabItemModel()
    
    var updatedAdressClosure: (DGrabItemModel)->Void = { _ in }

}
