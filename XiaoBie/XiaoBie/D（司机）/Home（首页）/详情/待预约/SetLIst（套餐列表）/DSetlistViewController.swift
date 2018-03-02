//
//  DSetlistViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DSetlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
        tableView.reloadData()
    }
    
    //MARK: - Request
    func updateSetRequest() {
        WebTool.post(uri:"update_order_info", para:["address": model.address, "gtcdw": setItemModel.plan_name, "order_id": model.id], success: { (dict) in
            let model = DToCheckUpdateAdressResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.updatedSetClosure(self.setItemModel)
                self.navigationController!.popViewController(animated: true)
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
        let cell = DSetCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        cell.selectedClosure = { [weak self] in
            self?.setItemModel = cell.model
            self?.updateSetRequest()
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
         navigationItem.title = "套餐"
    }

    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .plain)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var dataArray: [DSetItemModel] = []
    
    var updatedSetClosure: (DSetItemModel)->Void = { _ in }
    
    var setItemModel = DSetItemModel()
    
    var model = DGrabItemModel()
    
}
