//
//  DCodeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DCodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        setupNavigationBar()
        setupPopDestination()//将当前页面变成导航控制器推出的首页，无法返回待验单状态
        codeListRequest()
    }
    
    deinit {
        print("🐱")
    }

    //MARK: - Event Response
    @objc func transferButtonAction() {
        driverListRequest()
    }
    
    @objc func chatButtonAction() {
        print("聊天")
    }
    
    @objc func codeInputCellButtonAction() {
        codeRequest()
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
    
    func codeRequest() {
        let codeCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as! DCodeInputCodeCell
        
        WebTool.post(uri:"send_code_for_verify", para:["delivery_id": AccountTool.userInfo().id,
                                                       "verify_code": codeCell.code,
                                                       "order_id": model.id,
                                                       "dealer_id": dealerId], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.codeListRequest()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
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
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return codeListArray.count
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
            let scanCell = DCodeScanCell.cellWith(tableView: tableView)
            scanCell.serialNumber = serialNumber
            return scanCell
        case 2:
            let codeInputCell = DCodeInputCodeCell.cellWith(tableView: tableView)
            codeInputCell.codeButtonClosure = { [weak self] in
                self?.codeInputCellButtonAction()
            }
            return codeInputCell
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
        case 3:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 3:
            let sectionHeader = DCodeSectionHeaderCell.cellWith(tableView: tableView)
            return sectionHeader
        default:
            return UIView()
        }
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
    

    func setupPopDestination() {
        var controllerArray = navigationController?.viewControllers
        controllerArray = [(controllerArray?.first)!, (controllerArray?.last)!]
        navigationController?.setViewControllers(controllerArray!, animated: false)
    }
    
    //MARK: - Properties
    lazy var transferButtonItem = UIBarButtonItem.init(title: "转单", style: .plain, target: self, action: #selector(transferButtonAction))
    lazy var chatButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var model = DGrabItemModel()
    var codeListArray: [DCodeItemModel] = []
    var serialNumber = ""
    var dealerId = ""
    
}
