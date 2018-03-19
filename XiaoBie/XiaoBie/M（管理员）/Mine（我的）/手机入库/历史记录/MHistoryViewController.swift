//
//  MHistoryViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

class MHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(sourceView)
        view.addSubview(dateView)
        view.addSubview(blankView)
        view.addSubview(tableView)

        self.setupBlankView(isBlank: true, blankViewType: nil)
        setupFrame()//frame并不是screenBounds，因此不能在属性中直接设置
        
        loadRequest()
    }
    
    //MARK: - Action
    func sourceViewLabelTapAction() {
        paraPopView.showActionWith(type: .source)
    }
    
    func paraPopViewPickedAction(pickedItem: String) {
        source = pickedItem
        sourceView.sourceName = pickedItem
        loadRequest()
    }
    
    //MARK: - Request
    func loadRequest() {
        let staffId = AccountTool.userInfo().id
        WebTool.post(uri:"list_historical_stored_phone", para:["staff_id": staffId, "start_time": startDate, "end_time": endDate, "source": source, "page_num": "1", "page_size": pageSize], success: { (dict) in
            
            let model = DHistoryResponseModel.parse(dict: dict)
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
        let staffId = AccountTool.userInfo().id
        
        WebTool.post(uri:"list_historical_stored_phone", para:["staff_id": staffId, "start_time": startDate, "end_time": endDate, "source": source, "page_num": String(pageCount), "page_size": pageSize], success: { (dict) in

            let model = DHistoryResponseModel.parse(dict: dict)
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
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MHistoryCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    //MARK: - Setup
    func setupFrame() {
        sourceView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
    
        dateView.snp.makeConstraints { (make) in
            make.top.equalTo(sourceView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(dateView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(dateView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
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
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
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
    
    lazy var blankView: BlankView = {
        let blankView = BlankView()
        return blankView
    }()
    
    lazy var dateView: DHistoryDateView = {
        let view = DHistoryDateView()
        view.setupDate(startDate: startDate, endDate: endDate)
        return view
    }()
    
    lazy var sourceView = MHistorySourceView.viewWith { [weak self] in
        self?.sourceViewLabelTapAction()
    }
    
    lazy var paraPopView = MStoreParaPopView.viewWith(ownerVC: self) { (type, pickedItem) in
        self.paraPopViewPickedAction(pickedItem: pickedItem)
    }
    
    var dataArray: [DHistoryModel] = []

    var source = ""
    
    var pageCount = 0
    
    var startDate = ""
    var endDate = ""
}
