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
        view.addSubview(remindButton)
        setupNavigationBar()
        setupFrame()
    }
    
    deinit {
        print("🐱")
    }

    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "待查单"
        navigationItem.rightBarButtonItem = rightButtonItem
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
    
    //MARK: - Event Response
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func remindButtonAction() {
        print("提醒查单")
    }
    
    //MARK: - Request
    func clerkListRequest(serialNumber: String) {
        WebTool.get(uri:"get_dealer_by_serialno", para:["business_type": model.project_type,  "serial_no":"ff873985", "order_id":model.id], success: { (dict) in
            let model = DToCheckClerkResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.clerkListArray = model.data
                self.tableView.reloadSections(IndexSet.init(integer: 1), with: .fade)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return clerkListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let scanCell = DToCheckScanCell.cellWith(tableView: tableView)
            scanCell.ownerController = self
            scanCell.scanedClosure = {[weak self] serialNumber in
               self?.clerkListRequest(serialNumber: serialNumber)
            }
            return scanCell
        default:
            let clerkCell = DToCheckClerkCell.cellWith(tableView: tableView)
            clerkCell.model = clerkListArray[indexPath.row]
            if indexPath.row == 0 {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return clerkCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
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
    
    
    //MARK: - Properties
    lazy var rightButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_lt").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(chatButtonAction))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.bounces = false
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

    var clerkListArray: [DToCheckClerkModel] = []
    var model = DGrabItemModel()
    
}
