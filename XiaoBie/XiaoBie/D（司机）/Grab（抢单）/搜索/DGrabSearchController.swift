//
//  DGrabSearchController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/14.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh
import IQKeyboardManagerSwift

class DGrabSearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加
        view.addSubview(blankView)
        view.addSubview(tableView)
        grayView.addSubview(searchTextField)
        navigationItem.titleView = grayView
        navigationItem.rightBarButtonItem = searchButtonItem
        //设置
        view.backgroundColor = white_FFFFFF
        setupFrame()
        setupBlankView(isBlank: true, blankViewType: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    //MARK: - Action
    @objc func searchButtonAction() {
        searchTextField.resignFirstResponder()
        locationTool.startUpdatingLocation()
    }
    
    func locationToolCompleteAction(latitude: String, longitude: String) {
        self.location = (latitude, longitude)
        self.loadRequest()
    }
    
    func cellGrabButtonAction(indexPath: IndexPath) {
        grabRequest(indexPath: indexPath)
    }
    
    //MARK: - Request
    func loadRequest() {
        WebTool.post(isShowHud: false, uri:"list_original_order", para:["staff_id":AccountTool.userInfo().id, "latitude":location.latitude, "longitude":location.longitude, "project_type":"0", "page_num":"1", "page_size": pageSize, "address_key": searchTextField.text!], success: { (dict) in
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
        WebTool.post(isShowHud: false, uri:"list_original_order", para:["staff_id":AccountTool.userInfo().id, "latitude":location.latitude, "longitude":location.longitude, "project_type":"0", "page_num":String(pageCount), "page_size": pageSize, "address_key": searchTextField.text!], success: { (dict) in
            
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
                //列表中清空已抢单
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
        let cell = DGrabCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        cell.grabButtonClosure = { [weak self] in
            let corretIndexPath = tableView.indexPath(for: cell)// 获取真实 indexPath
            self?.cellGrabButtonAction(indexPath: corretIndexPath!)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonAction()
        return true
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
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField.init(frame: CGRect.init(x: 7, y: 0, width: screenWidth-39-56-7*2, height: 33))
        textField.textColor = black_333333
        textField.font = font14
        textField.attributedPlaceholder = NSAttributedString.init(string: "搜索内容...", attributes: [NSAttributedStringKey.font: font14, NSAttributedStringKey.foregroundColor: gray_9C9EA0])
        textField.returnKeyType = .search
        textField.delegate = self
        return textField
    }()
    
    lazy var grayView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth-39-56, height: 33))
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    lazy var searchButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "  搜索", style: .plain, target: self, action: #selector(searchButtonAction))
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        return buttonItem
    }()
    
    var location: (latitude: String, longitude: String) = ("", "")
    lazy var locationTool = LocationTool.toolWith { (latitude, longitude) in
        self.locationToolCompleteAction(latitude: latitude, longitude: longitude)
    }
    
    var dataArray: [DGrabItemModel] = []
    var pageCount = 0
}
