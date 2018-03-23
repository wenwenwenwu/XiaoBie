//
//  DPayViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DPayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        setupFrame()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航控制器返回按钮
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesBackButton = false
    }
    
    //MARK: - Event Response
    @objc func confirmButtonEvent() {
        let moneyCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! DPayMoneyCell
        let payMoney = moneyCell.payMoney
        
        if payMoney.isEmpty {
            HudTool.showInfo(string: "请输入金额")
            return
        }
        
        if payMoney == "0" && payMethod != .cash {
            HudTool.showInfo(string: "金额为0时只能选择现金收款")
            return
        }
        
        if payMethod == .cash {
            confirmRequest()
        } else {
            //跳转付款二维码
            let QRController = DQRCodeViewController.controllerWith(payMethod: payMethod, payMoney: payMoney, model: model)
            navigationController?.pushViewController(QRController, animated: true)
        }
    }
    
    //MARK: - Request
    func confirmRequest() {
        WebTool.post(uri:"payment_submit", para:["staff_id": AccountTool.userInfo().id, "plat_form_type": String(payMethod.rawValue), "order_id": model.id], success: { (dict) in
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let payMoneyCell = DPayMoneyCell.cellWith(tableView: tableView)
            return payMoneyCell
        default:
            let payMethodCell = DPayMethodCell.cellWith(tableView: tableView)
            switch indexPath.row {
            case 0:
                payMethodCell.payMethod = .zhifubao
            case 1:
                payMethodCell.payMethod = .weixin
            default:
                payMethodCell.payMethod = .cash
            }
            //首个选中
            if indexPath.row == 0 {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            
            return payMethodCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! DPayMethodCell
            payMethod = cell.payMethod
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 133
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "代收金额"
    }
    
    func setupFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 56, 0))
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.bottom.equalTo(-10)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("确认收款", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonEvent), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel()
    
    var payMethod: PayMethod = .zhifubao
}
