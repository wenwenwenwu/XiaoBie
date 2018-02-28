//
//  MyMoneyViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

class MyMoneyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(infoView)
        view.addSubview(blankView)
        view.addSubview(tableView)
        setupNavigationBar()
        setupBlankView(isBlank: true, blankViewType: nil)
        infoRequest()
        loadRequest()

    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "我的税前酬金"
        navigationItem.rightBarButtonItem = cashButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
    }
    
    func setupBlankView(isBlank: Bool, blankViewType: ViewType?) {
        tableView.isHidden = isBlank
        blankView.viewType = blankViewType
        blankView.buttonClosure = { [weak self] in
            if self?.blankView.viewType == .noWeb {
                self?.loadRequest()
            }
        }
    }
    
    //MARK: - Request
    func infoRequest() {
        WebTool.post(uri: "reward_profile", para: ["staff_id" : AccountTool.userInfo().id], success: { (dict) in
            let model = MyMoneyInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.infoView.model = model.data
            }else{
                
            }
        }) { (error) in
            
        }
    }
    
    func loadRequest() {
        WebTool.post(uri:"get_earning_list", para:["delivery_id": AccountTool.userInfo().id, "start_time": startDate, "end_time": endDate, "page_num": "1", "page_size": pageSize], success: { (dict) in
            let model = MyMoneyItemResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.dataArray = model.data
                //数据展示
                if !self.dataArray.isEmpty {
                    //重置loadMore请求页数
                    self.pageCount = 2
                    //设置上拉状态
                    if self.dataArray.count == Int(pageSize) {
                        self.tableView.mj_footer.resetNoMoreData()//恢复"下拉加载更多"
                    } else {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()//显示"没有更多数据"
                    }
                    //数据刷新
                    self.tableView.reloadData()
                    self.setupBlankView(isBlank: false, blankViewType: nil)
                }else{
                    self.setupBlankView(isBlank: true, blankViewType: .noData)
                }
            }else{
                self.setupBlankView(isBlank: true, blankViewType: .noWeb)
            }
        }) { (error) in
            self.setupBlankView(isBlank: true, blankViewType: .noWeb)
        }
        //停止上拉刷新
        self.tableView.mj_header.endRefreshing()
    }
    
    func loadMoreRequest() {
        WebTool.post(uri:"get_earning_list", para:["delivery_id": AccountTool.userInfo().id, "start_time": startDate, "end_time": endDate, "page_num": String(pageCount), "page_size": pageSize], success: { (dict) in
            
            let model = MyMoneyItemResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.dataArray += model.data
                //数据展示
                if model.data.count != 0 {
                    self.pageCount += 1
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()//显示"没有更多数据"
                }
            }else{
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
        //停止上拉刷新
        self.tableView.mj_footer.endRefreshing()
    }
    
    func cashRequest() {
        WebTool.post(uri: "request_withdraw", para: ["staff_id" : AccountTool.userInfo().id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Event Response
    @objc func cashButtonAction() {
        Alert.showAlertWith(style: .alert, controller: self, title: "确认申请提现(清零总结算)？", message: nil, buttons: ["确定"]) { _ in
            self.cashRequest()
        }
    }
    
    func popupCalendar() {
        //弹出
        let calendarVC = CalendarViewController()
        calendarVC.startDate = startDate
        calendarVC.endDate = endDate
        
        calendarVC.doneClosure = { startDate, endDate in
            self.startDate = startDate
            self.endDate = endDate
            self.loadRequest()
        }
        let calendarNC = NavigationController.init(rootViewController: calendarVC)
        self.present(calendarNC, animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyMoneyCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    

    //MARK: - Properties
    lazy var cashButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "提现", style: .plain, target: self, action: #selector(cashButtonAction))
        return buttonItem
    }()
    
    lazy var infoView: MyMoneyInfoView = {
        let view = MyMoneyInfoView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 145))
        view.calendarButtonClosure = {
            self.popupCalendar()
        }
        return view
    }()
    
    lazy var blankView: BlankView = {
        let blankView = BlankView.init(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: screenHeight-infoView.height-navigationBarHeight))
        return blankView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: screenHeight-infoView.height-navigationBarHeight), style: .plain)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.dataSource = self
        tableView.delegate = self
        //下拉刷新
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {  [weak self] in
            self?.loadRequest()
        })
        //上拉加载更多
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            self?.loadMoreRequest()
        })
        return tableView
    }()
    
    var dataArray: [MyMoneyItemModel] = []
    var pageCount = 0
    
    var startDate = ""
    var endDate = ""
}
