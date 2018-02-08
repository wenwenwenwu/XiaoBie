//
//  MineViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
        setupNavigationBar()
    }

    //MARK: - Setup
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Event Response
    func phoneCellAction() {
        print("领手机")
    }
    
    func queryCellAction() {
        print("销售查询")
    }
    
    func uploadCellAction() {
        print("上传凭证")
    }
    
    func monyCellAction() {
        print("我的睡前酬金")
    }
    
    func setupCellAction() {
        print("设置")
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineCell.cellWith(tableView: tableView)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.type = .phone
            case 1:
                cell.type = .query
            case 3:
                cell.type = .upload
            default:
                cell.type = .money
            }
        default:
            cell.type = .setup
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MineCell
        switch cell.type {
            case .phone:
                phoneCellAction()
            case .query:
                queryCellAction()
            case .upload:
                uploadCellAction()
            case .money:
                monyCellAction()
            default:
                setupCellAction()
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
    
    lazy var headView = MyHeader()
}
