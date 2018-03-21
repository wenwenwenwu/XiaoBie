//
//  CHomeListViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/13.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

enum CHomeListType {
    /*
     0-待查单
     1-待验单
     2-待添加营销案
     3-完成
     */
    case toCheck
    case toTestify
    case toAdd
    case complete
}

class CHomeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Factory Method
    class func controllerWith(listType: CHomeListType) -> CHomeListViewController {
        let viewController = CHomeListViewController()
        viewController.listType = listType
        return viewController
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blankView)
        view.addSubview(tableView)
        self.setupBlankView(isBlank: true, blankViewType: nil)
        setupFrame()//frame并不是screenBounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRequest()
    }
    
    //MARK: - Event Response
    func pushedVCupdatedAddressAction(indexPath: IndexPath, model: DGrabItemModel) {
        let cell = tableView.cellForRow(at: indexPath) as! DHomeListCell
        cell.model = model
    }
    
    //MARK: - Request
    func loadRequest() {
        WebTool.post(isShowHud: false, uri:"get_order_list_for_dealer", para:["staff_id":AccountTool.userInfo().id, "query_type":queryType, "page_num": "1"], success: { (dict) in
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
        WebTool.post(isShowHud: false, uri:"get_order_list_for_delivery", para:["staff_id":AccountTool.userInfo().id, "query_type":queryType, "page_num": String(pageCount)], success: { (dict) in
            
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
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CHomeListCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CHomeListCell
//        cell.model.statusType = .toCheck
        switch listType {
        case .toCheck:
            let toCheckVC = MToCheckViewController()
            toCheckVC.model = cell.model
            navigationController?.pushViewController(toCheckVC, animated: true)
        case .toTestify:
            let toTestifyVC = MToTestifyViewController()
//            toTestifyVC.model = cell.model
            navigationController?.pushViewController(toTestifyVC, animated: true)
        case .toAdd:
            let toAddVC = MAddViewController()
            toAddVC.model = cell.model
            navigationController?.pushViewController(toAddVC, animated: true)
        case .complete:
            let completeVC = MAddViewController()
            completeVC.model = cell.model
            navigationController?.pushViewController(completeVC, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
    
    var queryType = ""
    var listType: CHomeListType = .toCheck {
        didSet{
            switch listType {
            case .toCheck:
                queryType = "0"
            case .toTestify:
                queryType = "1"
            case .toAdd:
                queryType = "2"
            case .complete:
                queryType = "3"
            }
        }
    }
    
    var dataArray: [DGrabItemModel] = []
    
    var pageCount = 0
}

