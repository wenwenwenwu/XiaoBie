//
//  DSetupViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DSetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
       navigationItem.title = "设置"
    }
    
    //MARK: - Event Response
    func clearCellAction() {
        //提示清空缓存
        Alert.showAlertWith(style: .alert, controller: self, title: "确定清空缓存吗", message: nil, buttons: ["确定"]) { _ in
            //清空硬盘缓存
            CacheTool.clearCache()
            //刷新数据
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
        }
    }
    
    func rankCellAction() {
        print("给龙网评分")
    }
    
    func pravicyCellAction() {
        print("隐私协议")
    }
    
    func suggestCellAction() {
        print("建议与反馈")
    }
    
    func aboutCellAction() {
        print("关于我们")
    }
    
    func logoutCellAction() {
        //删除用户信息
        AccountTool.logout()
        NIMSDK.shared().loginManager.logout { (error) in
            
        }
        //弹出登录界面
        let loginNC = NavigationController.init(rootViewController: LoginViewController())
        mainVC.present(loginNC, animated: false, completion: nil)
        //清空当前角色页面
        let childVC = mainVC.childViewControllers[0]
        childVC.removeFromParentViewController()
        childVC.view.removeFromSuperview()
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = DSetupCell.cellWith(tableView: tableView)
            switch indexPath.row {
            case 0:
                cell.type = .clear
            case 1:
                cell.type = .rank
            case 3:
                cell.type = .suggest
            default:
                cell.type = .privacy
            }
            return cell
        case 1:
            let cell = DSetupCell.cellWith(tableView: tableView)
            cell.type = .about
            return cell
        default:
            let cell = DLogoutCell.cellWith(tableView: tableView)
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell!.isKind(of: DSetupCell.self) {
            let setupCell = cell as! DSetupCell
            switch setupCell.type {
            case .clear:
                clearCellAction()
            case .rank:
                rankCellAction()
            case .privacy:
                pravicyCellAction()
            case .suggest:
                suggestCellAction()
            case .about:
                aboutCellAction()
            }
        } else {
            logoutCellAction()
        }
    }
    
    //变化的sectionHeight要在代理中采用四种方法组合设置才有效，tableView中设置没有用
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //MARK: - Lazyload
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    

}
