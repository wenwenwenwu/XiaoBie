//
//  IInStoreViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

class IInStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.addSubview(blankView)
        view.addSubview(tableView)
        
        view.backgroundColor = gray_F5F5F5
        setupBlankView(isBlank: true, blankViewType: nil)
        setupFrame()
        
        loadRequest()
    }
    

    //MARK: - Action
    func sourceViewTapAction() {
        paraPopView.showActionWith(type: .source, currentItem: sourceView.paraLabel.text == "来源" ? "所有来源" : sourceView.paraName)
    }
    
    func modelViewTapAction() {
        paraPopView.showActionWith(type: .phoneModel, currentItem: modelView.paraLabel.text == "型号" ? "所有型号" : modelView.paraName)
    }
    
    func paraViewTapAction() {
        guard modelView.paraLabel.text != "型号" else {
            HudTool.showInfo(string: "请先选择型号")
            return
        }
        paraPopView.modelId = self.modelId
        paraPopView.showActionWith(type: .phonePara, currentItem: paraView.paraLabel.text == "筛选" ? "所有参数" : paraView.paraName)
    }
    
    func paraPopViewPickedAction(type: IStoreParaType, model: MHistoryPickParaModel) {
        
        switch type {
        case .source:
            let pickedItem = model.source_name
            source = (pickedItem == "所有来源") ? "" : pickedItem
            sourceView.paraName = pickedItem
            sourceId = (pickedItem == "所有来源") ? "" : model.id
        case .phoneModel:
            let pickedItem = model.model_name
            self.model = (pickedItem == "所有型号") ? "" : pickedItem
            modelView.paraName = pickedItem
            modelId = (pickedItem == "所有型号") ? "" : model.id
        case .phonePara:
            let pickedItem = model.param_name
            memory = (pickedItem == "所有参数") ? "" : pickedItem
            paraView.paraName = pickedItem
        }        
        loadRequest()
    }
    
    //MARK: - Request
    func phoneInStoreRequest(serialNumber: String) {
        WebTool.post(uri: "store_phone", para: ["staff_id": AccountTool.userInfo().id,
                                                "memory": memory,
                                                "model": model,
                                                "source_id":sourceId,
                                                "serial_no": serialNumber], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.loadRequest()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func loadRequest() {
        print("memory:\(memory)")
        print("model:\(model)")
        print("source:\(source)")

        WebTool.post(uri:"list_stored_phone", para:["staff_id": AccountTool.userInfo().id, "memory": memory, "model": model, "source": source, "page_num": "1", "page_size": pageSize], success: { (dict) in
            
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
        WebTool.post(uri:"list_stored_phone", para:["staff_id": AccountTool.userInfo().id, "memory": memory, "model": model, "source": source, "page_num": String(pageCount), "page_size": pageSize], success: { (dict) in
            
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
        stackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
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
    lazy var sourceView = IInStoreParaView.viewWith(type: .source) { [weak self] in
        self?.sourceViewTapAction()
    }
    
    lazy var modelView = IInStoreParaView.viewWith(type: .phoneModel) { [weak self] in
        self?.modelViewTapAction()
    }
    
    lazy var paraView = IInStoreParaView.viewWith(type: .phonePara) { [weak self] in
        self?.paraViewTapAction()
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40))
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sourceView)
        stackView.addArrangedSubview(modelView)
        stackView.addArrangedSubview(paraView)
        return stackView
    }()
    
//    lazy var paraPopView = MStoreParaPopView.viewWith(ownerVC: self) { (type, model) in
//        self.paraPopViewPickedAction(type: type, model: model)
//    }
    
    lazy var paraPopView = IStoreParaPopView.init(ownerVC: self) { [weak self] (type, model) in
        self?.paraPopViewPickedAction(type: type, model: model)
    }
    
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
    
    var dataArray: [DHistoryModel] = []
    var pageCount = 0
    
    
    var source = ""
    var sourceId = "" //手机入库请求需要
    var model = ""
    var modelId = "" //手机参数请求需要
    var memory = ""    
    
}
