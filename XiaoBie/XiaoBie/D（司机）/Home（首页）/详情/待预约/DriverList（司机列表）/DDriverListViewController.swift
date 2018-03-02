//
//  DDriverListViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DDriverListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        view.addSubview(transferButton)
        setupNavigationBar()
        setupFrame()
        tableView.reloadData()
    }
    
    //MARK: - Event Response
    @objc func transferButtonAction() {
        transferRequest()
    }
    
    //MARK: - Request
    func transferRequest() {
        WebTool.post(uri:"transfer_order", para:["target_staff_id": driverItemModel.id, "order_id": model.id], success: { (dict) in
            let model = DDriverListResponseModel.parse(dict: dict)
            if model.code == "0" {
                let homeVC = self.navigationController?.viewControllers[0] as! DHomeViewController
                //待预约页面更新
                let toOrderVC = homeVC.toOrderVC
                toOrderVC.loadRequest()
                //跳转回首页主页面
                self.navigationController?.popToViewController(homeVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
        
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DDriverCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        cell.selectedClosure = { [weak self] in
            self?.driverItemModel = cell.model
        }
        //shou ge xuan zhong
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "转单"
    }
    
    func setupFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 56, 0))
        }
        
        transferButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.bottom.equalTo(-10)
            make.height.equalTo(36)
        }
        
    }
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var transferButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("确认转单", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(transferButtonAction), for: .touchUpInside)
        return button
    }()
    
    var dataArray: [DDriverItemModel] = [] {
        didSet {
            driverItemModel = dataArray[0]
        }
    }
    var driverItemModel = DDriverItemModel()
    var model = DGrabItemModel()
    
}
