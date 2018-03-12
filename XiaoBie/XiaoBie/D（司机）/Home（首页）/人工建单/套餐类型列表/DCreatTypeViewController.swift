//
//  DCreatTypeLevelViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DCreatSetTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
        tableView.reloadData()
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    func cellSelectedAction(title: String) {
        self.cellSelectedClosure(title)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DCreatSetTypeCell.cellWith(tableView: tableView)
        cell.title = dataArray[indexPath.row]
        cell.selectedClosure = { [weak self] title in
            self?.cellSelectedAction(title: title)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "套餐类型"
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
    
    var dataArray = ["手机", "宽带"]
    
    var cellSelectedClosure: (String)->Void = { _ in }
    
}
