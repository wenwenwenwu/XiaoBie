//
//  DGrabListViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

enum DGrabListType {
    case all
    case phone
    case web
}

class DGrabListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Factory Method
    class func controllerWith(listType: DGrabListType) -> DGrabListViewController {
        let viewController = DGrabListViewController()
        viewController.listType = listType
        return viewController
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blankView)
        view.addSubview(tableView)
        self.setupBlankView(isBlank: true, blankViewType: nil)
        setupFrame()//frame并不是screenBounds，因此不能在属性中直接设置
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTool.startUpdatingLocation()
    }
    
    //MARK: - Setup
    func setupFrame() {
        blankView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
    
    //MARK: - Event Response
    func grabButtonAction(indexPath: IndexPath) {
        grabRequest(indexPath: indexPath)
    }
        
    //MARK: - Request
    func loadRequest() {
        let staffId = AccountTool.userInfo().id
        let latitude = location.latitude
        let longitude = location.longitude
        
        WebTool.post(isShowHud: false, uri:"list_original_order", para:["staff_id":staffId, "latitude":latitude, "longitude":longitude, "project_type":projectType, "page_num":"1", "page_size": pageSize], success: { (dict) in
            let model = DGrabItemResponseModel.parse(dict: dict)
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
        let latitude = location.latitude
        let longitude = location.longitude
        
        WebTool.post(isShowHud: false, uri:"list_original_order", para:["staff_id":staffId, "latitude":latitude, "longitude":longitude, "project_type":"2", "page_num":String(pageCount), "page_size": pageSize], success: { (dict) in
            
            let model = DGrabItemResponseModel.parse(dict: dict)
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
                HudTool.showInfo(string: model.message)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
        //停止上拉刷新
        self.tableView.mj_footer.endRefreshing()
    }
    
    func grabRequest(indexPath: IndexPath) {
        let staffId = AccountTool.userInfo().id
        let orderId = dataArray[indexPath.row].id
        
        WebTool.post(isShowHud: false, uri:"grab_order", para:["staff_id":staffId, "order_id":orderId], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.dataArray.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
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
        let cell = DGrabListCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        cell.grabButtonClosure = { [weak self] in
            let corretIndexPath = tableView.indexPath(for: cell)// 获取真实 indexPath
            self?.grabButtonAction(indexPath: corretIndexPath!)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
    
    var location: (latitude: String, longitude: String) = ("", "")
    lazy var locationTool = LocationTool.toolWith { (latitude, longitude) in
        self.location = (latitude, longitude)
        self.loadRequest()
    }
    
    var projectType = ""
    var listType: DGrabListType = .all {
        didSet{
            switch listType {
            case .phone:
                projectType = "0"
            case .web:
                projectType = "1"
            case .all:
                projectType = "2"
            }
        }
    }
    
    var dataArray: [DGrabItemModel] = []
    var pageCount = 0
    
}

