//
//  MCompleteViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CCompleteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = chatButtonItem
        view.addSubview(tableView)
        //本页面订单状态有两种类型，.complete2 和 .paySuccess
        whiteView.isHidden = (model.statusType == .complete2)
        view.addSubview(whiteView)
        whiteView.addSubview(doneButton)
        
        navigationItem.title = "已完成"
        view.backgroundColor = white_FFFFFF
        codeListRequest()
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    @objc func chatButtonAction() {
        chatSessionRequest()
    }
    
    @objc func doneButtonAction() {
        doneRequest()
    }
    
    //MARK: - Request
    func chatSessionRequest() {
        WebTool.post(uri: "get_groupid_by_staffid",para: ["staff_id": AccountTool.userInfo().id], success: { (dict) in
            let model = CChatSessionResponseModel.parse(dict: dict)
            if model.code == "0" {
                let session = NIMSession.init(model.data, type: NIMSessionType.init(rawValue: 1)!)
                let vc = NIMSessionViewController.init(session: session)
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func codeListRequest() {
        WebTool.get(uri:"list_verify_code", para:["order_id":model.id], success: { (dict) in
            let model = DCodeListResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.codeListArray = model.data
                self.tableView.reloadData()
            } else {
                
            }
        }) { (error) in
            
        }
    }
    
    func doneRequest() {
        WebTool.post(uri: "settle_order_status", para: ["target_status":"17", "order_id":model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.navigationController?.popViewController(animated: true)
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
        case 1:
            return codeListArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let infoCell = CCompleteInfoCell.cellWith(tableView: tableView)
            infoCell.model = model
            return infoCell
        default:
            let codeCell = DCodeCodeCell.cellWith(tableView: tableView)
            codeCell.model = codeListArray[indexPath.row]
            return codeCell
        }
    }
    
    //MARK: - UITableViewDelegate
    //变化的sectionHeight要在代理中采用四种方法组合设置才有效，tableView中设置没有用
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let sectionHeader = DCodeSectionHeaderCell.cellWith(tableView: tableView)
            return sectionHeader
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //MARK: - Properties
    lazy var chatButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(chatButtonAction))
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : black_333333], for: .highlighted)
        return barButtonItem
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: screenHeight-navigationBarHeight-56, width: screenWidth, height: 56))
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 13, y: 10, width: screenWidth - 13 * 2, height: 36)
        button.titleLabel?.font = font14
        button.setTitle("确认完成", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel()
    var codeListArray: [DCodeItemModel] = []
}
