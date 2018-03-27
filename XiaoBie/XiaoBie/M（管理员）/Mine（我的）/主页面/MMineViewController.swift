//
//  MMineViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        //刷新数据
        headView.model = AccountTool.userInfo()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Action
    @objc func headViewTapAction() {
        Alert.showAlertWith(style: .actionSheet, controller: self, title: nil, message: nil, functionButtons: ["相机", "相册"]) { (title) in
            switch title {
            case "相机":
                self.avatarPickerTool.openCamera()
            default:
                self.avatarPickerTool.openAlbum()
            }
        }
    }
    
    func photoPickerToolCompleteUploadEvent(imageName: String) {
        updateAvatarRequest(imageName: imageName)
    }
    
    //MARK: - Request
    func updateAvatarRequest(imageName: String) {
        WebTool.post(uri: "update_employee_info", para: ["employee_id" : AccountTool.userInfo().id, "avatar": imageName], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                //更新avatarImageView
                let urlStr = "\(avatarURL)\(imageName)"
                self.headView.avatarImageView.kf.setImage(with: URL.init(string: urlStr), placeholder: gray_D9D9D9.colorImage(), options: nil, progressBlock: nil, completionHandler: nil)
                //更新userInfoModel
                let userInfoModel = AccountTool.userInfo()
                userInfoModel.avatar = imageName
                AccountTool.login(with: userInfoModel)
                
                
            } else {
                HudTool.showInfo(string: model.msg)
            }
            
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DMineCell.cellWith(tableView: tableView)
        cell.type = .setting
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! DMineCell
        switch cell.type {
        case .inStore:
            let storeVC = IStoreViewController()
            storeVC.startDate = startDate
            storeVC.endDate = endDate
            navigationController?.pushViewController(storeVC, animated: true)
        default:
            navigationController?.pushViewController(DSetupViewController(), animated: true)
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
    
    lazy var headView: DMyHeader = {
        let view = DMyHeader()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(headViewTapAction))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var avatarPickerTool = AvatarPickerTool.toolWith(ownerViewController: self) { [weak self] (imageName, localUrl) in
        self?.photoPickerToolCompleteUploadEvent(imageName: imageName)
    }
    
    var startDate = DateTool.str本月一号()
    var endDate = DateTool.str今天()
}
