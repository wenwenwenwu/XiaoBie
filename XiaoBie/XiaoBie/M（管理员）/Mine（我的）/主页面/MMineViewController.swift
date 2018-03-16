//
//  MMineViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        //刷新数据
        headView.model = AccountTool.userInfo()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DMineCell.cellWith(tableView: tableView)
        switch indexPath.section {
        case 0:
            cell.type = .inStore
        default:
            cell.type = .setting
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! DMineCell
        switch cell.type {
        case .inStore:
            let storeVC = MStoreViewController()
            storeVC.startDate = startDate
            storeVC.endDate = endDate
            navigationController?.pushViewController(storeVC, animated: true)
        default:
            navigationController?.pushViewController(DSetupViewController(), animated: true)
        }
    }
    
    //MARK: - Lazyload
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight-statusBarHeight), style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = headView
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 11
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var headView = DMyHeader()
    
    var startDate = DateTool.str本月一号()
    var endDate = DateTool.str今天()
}
