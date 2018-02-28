//
//  DAlibiViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import MJRefresh

class DAlibiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(photoButtonView1)
        
        photoButtonView2.isHidden = true
        view.addSubview(photoButtonView2)
        
        photoButtonView3.isHidden = true
        view.addSubview(photoButtonView3)
        
        view.addSubview(uploadButton)
        view.addSubview(grayView)
        grayView.addSubview(timeLabel)
        grayView.addSubview(calendarButton)
        view.addSubview(blankView)
        view.addSubview(tableView)
        
        setupNavigationBar()
        setupFrame()
        setupBlankView(isBlank: true, blankViewType: nil)
        
        loadRequest()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "上传凭证"
    }
    
    func setupFrame() {
        photoButtonView1.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButtonView2.snp.makeConstraints { (make) in
            make.left.equalTo(photoButtonView1.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButtonView3.snp.makeConstraints { (make) in
            make.left.equalTo(photoButtonView2.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        uploadButton.snp.makeConstraints { (make) in
            make.top.equalTo(105)
            make.right.equalTo(-13)
            make.width.equalTo(76)
            make.height.equalTo(31)
        }
        
        grayView.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        calendarButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        blankView.snp.makeConstraints { (make) in
            make.top.equalTo(grayView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(grayView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
    
    //MARK: - Request
    func uploadRequest(imageNames: String) {
        WebTool.post(uri: "upload_daily_evidence", para: ["staff_id" : AccountTool.userInfo().id, "image_names": imageNames], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                HudTool.showInfo(string: model.msg)
                self.loadRequest()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func loadRequest() {
        WebTool.post(uri:"get_daily_evidence_list", para:["staff_id": AccountTool.userInfo().id, "start_time": startDate, "end_time": endDate, "page_num": "1", "page_size": pageSize], success: { (dict) in
            let model = DAlibiResponseModel.parse(dict: dict)
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
        WebTool.post(uri:"get_daily_evidence_list", para:["staff_id": AccountTool.userInfo().id, "start_time": startDate, "end_time": endDate, "page_num": String(pageCount), "page_size": pageSize], success: { (dict) in
            
            let model = DAlibiResponseModel.parse(dict: dict)
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
    
    //MARK: - Event Response
    @objc func uploadButtonAction() {
        guard !photoButtonView1.url.isEmpty && !photoButtonView2.url.isEmpty && !photoButtonView3.url.isEmpty else {
            HudTool.showInfo(string: "必须上传3张图片")
            return
        }
        let imageNames = "\(photoButtonView1.url),\(photoButtonView2.url),\(photoButtonView3.url)"
        uploadRequest(imageNames: imageNames)
    }
    
    @objc func calendarButtonAction() {
        //弹出
        let calendarVC = CalendarViewController()
        calendarVC.startDate = startDate
        calendarVC.endDate = endDate
        
        calendarVC.doneClosure = { startDate, endDate in
            self.startDate = startDate
            self.endDate = endDate
            self.timeLabel.text = "\(startDate)  至  \(endDate)"
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
        let cell = DAlibiCell.cellWith(tableView: tableView)
        cell.model = dataArray[indexPath.row]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }


    //MARK: - Properties
    lazy var photoButtonView1 = DPhotoButtonView.viewWith(ownVC: self) { [weak self] in
        self?.photoButtonView2.isHidden = false
    }

    lazy var photoButtonView2 = DPhotoButtonView.viewWith(ownVC: self) { [weak self] in
        self?.photoButtonView3.isHidden = false
    }

    lazy var photoButtonView3 = DPhotoButtonView.viewWith(ownVC: self) {

    }
    
    lazy var uploadButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.titleLabel?.font = font12
        button.setTitle("确认上传", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(startDate)  至  \(endDate)"
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_rl"), for: .normal)
        button.addTarget(self, action: #selector(calendarButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var blankView: BlankView = {
        let blankView = BlankView.init(frame: CGRect.zero)
        return blankView
    }()
    
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
    
    var dataArray: [DAlibiModel] = []
    var pageCount = 0
    
    var startDate = ""
    var endDate = ""
}
