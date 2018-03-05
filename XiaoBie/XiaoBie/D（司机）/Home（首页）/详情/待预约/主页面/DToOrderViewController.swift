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
    @objc func transferButtonAction() {
        driverListRequest()
    }
    
    func setPickCellAction() {
        setListRequest()
    }
    
    @objc func cancelButtonAction() {
        cancelRequest()
    }
    
    @objc func orderButtonAction() {
        orderRequest()
    }
    
    func infoCellupdatedAddressAction(model: DGrabItemModel) {
        //刷新当前页面
        self.model.address = model.address
        self.model.distance = model.distance
        tableView.reloadData()
        //刷新列表页面
        updatedAdressClosure(model)
    }
    
    func setListVCUpdatedSetAction(model: DSetItemModel) {
        //保存套餐
        self.model.gtcdw = model.plan_name
        //套餐名称显示
        let setPickerCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! DToOrderSetPickCell
        setPickerCell.setName = model.plan_name
    }
    
    //MARK: - Request
    func cancelRequest() {
        WebTool.post(isShowHud: false, uri:"cancel_order", para:["order_id":model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                let homeVC = self.navigationController?.viewControllers[0] as! DHomeViewController
                //待预约页面更新
                let toOrderVC = homeVC.toOrderVC
                toOrderVC.loadRequest()
                //跳转回首页主页面
                self.navigationController?.popToViewController(homeVC, animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    
    func setListRequest() {
        WebTool.get(uri:"query_plan_type", para:["business_type": model.project_type], success: { (dict) in
            let model = DSetListResponseModel.parse(dict: dict)
            if model.code == "0" {
                let setListVC = DSetlistViewController()
                setListVC.dataArray = model.data
                setListVC.model = self.model
                setListVC.updatedSetClosure = { setItemModel in
                    self.setListVCUpdatedSetAction(model: setItemModel)
                }
                self.navigationController?.pushViewController(setListVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
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
    
    func orderRequest() {
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
            infoCell.updatedAddressClosure = { [weak self] model in
                self?.infoCellupdatedAddressAction(model: model)
            }
            return infoCell
        default:
            let setPickCell = DToOrderSetPickCell.cellWith(tableView: tableView)
            setPickCell.setName = model.gtcdw
            return setPickCell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            setPickCellAction()
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
    lazy var rightButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_zd").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(transferButtonAction))
    
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
