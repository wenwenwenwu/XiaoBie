//
//  DMineViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    //MARK: - Event Response
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
    
    func phoneCellAction() {
        let myPhoneVC = DMyPhoneViewController()
        myPhoneVC.startDate = startDate
        myPhoneVC.endDate = endDate
        navigationController?.pushViewController(myPhoneVC, animated: true)
    }
    
    @objc func queryCellAction() {
        print("销售查询")
    }
    
    func uploadCellAction() {
        let alibiVC = DAlibiViewController()
        alibiVC.startDate = startDate
        alibiVC.endDate = endDate
        navigationController?.pushViewController(alibiVC, animated: true)
    }
    
    func monyCellAction() {
        let moneyVC = DMyMoneyViewController()
        moneyVC.startDate = startDate
        moneyVC.endDate = endDate
        navigationController?.pushViewController(moneyVC, animated: true)
    }
    
    func settingCellAction() {
        navigationController?.pushViewController(DSetupViewController(), animated: true)
    }
    
    //MARK: - Request
    func updateAvatarRequest(imageName: String) {
        WebTool.post(uri: "update_employee_info", para: ["employee_id" : AccountTool.userInfo().id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                //更新avatarImageView
                let urlStr = "http://manage.cloudconfs.com:8080/longwang/oss/load_avatar?avatar=\(imageName)"
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DMineCell.cellWith(tableView: tableView)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.type = .phone
            case 1:
                cell.type = .query
            case 3:
                cell.type = .upload
            default:
                cell.type = .money
            }
        default:
            cell.type = .setting
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! DMineCell
        switch cell.type {
            case .phone:
                phoneCellAction()
            case .query:
                queryCellAction()
            case .upload:
                uploadCellAction()
            case .money:
                monyCellAction()
            default:
                settingCellAction()
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
