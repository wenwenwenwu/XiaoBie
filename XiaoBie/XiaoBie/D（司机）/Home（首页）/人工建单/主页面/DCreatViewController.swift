//
//  DCreatViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DCreatViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
    }
    
    //MARK: - Event Response
    @objc func cancelButtonAction() {
        resignKeyBoardInView(view: view)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
        guard ValidateTool.isPhoneNumber(vStr: phone) else {
            HudTool.showInfo(string: "请输入正确的手机号")
            return
        }
        
        guard ValidateTool.isIDCard(vStr: ID) else {
            HudTool.showInfo(string: "请输入正确的身份证号")
            return
        }
        
        guard address.count >= 5 else {
            HudTool.showInfo(string: "地址不小于5个字")
            return
        }
        
        creatRequest()
    }
    
    func textFieldCellendEditAction(text: String, cellType: DCreatTextFieldCellType ) {
        switch cellType {
        case .name:
            name = text
        case .phone:
            phone = text
        case .ID:
            ID = text
        }
        setupDoneButton()
    }
    
    func textViewCellEndEditAction(text: String) {
        address = text
        setupDoneButton()
    }
    
    func setTypeListVCCellSelectedAction(setType: String)  {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! DCreatCell
        cell.pickLabel.text = setType
        if setType == "手机" {
            self.setType = "0"
        } else {
            self.setType = "1"
            
        }
        setupDoneButton()
    }
    
    func setLevelListVCCellSelectedAction(model: DSetItemModel)  {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1)) as! DCreatCell
        cell.pickLabel.text = model.plan_name
        self.setLevelModel = model
        setupDoneButton()
    }
    
    
    //MARK: - Request
    func setLevelListRequest() {
        WebTool.get(uri:"query_plan_type", para:[:], success: { (dict) in
            let model = DSetListResponseModel.parse(dict: dict)
            if model.code == "0" {
                let setLevelListVC = DCreatSetLevelViewController()
                setLevelListVC.dataArray = model.data
                setLevelListVC.cellSelectedClosure = { setItemModel in
                    self.setLevelListVCCellSelectedAction(model: setItemModel)
                }
                self.navigationController?.pushViewController(setLevelListVC, animated: true)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    func creatRequest() {
        WebTool.get(uri:"create_order_manual", para:["project_type": setType,
                                                     "address": address,
                                                     "phone": phone,
                                                     "user_name": name,
                                                     "staff_id": AccountTool.userInfo().id,
                                                     "id_num": ID,
                                                     "plan_id": setLevelModel.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                HudTool.showInfo(string: "新建完成，请在待验单列表中查看")
                self.navigationController?.dismiss(animated: true, completion: nil)
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
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let textFieldCell = DCreatTextFieldCell.cellWith(tableView: tableView)
            textFieldCell.textFieldEndEditClosure = { [weak self] text, cellType in
                self?.textFieldCellendEditAction(text: text, cellType: cellType)
            }
            switch indexPath.row {
            case 0:
                textFieldCell.cellType = .name
                return textFieldCell
            case 1:
                textFieldCell.cellType = .phone
                return textFieldCell
            case 2:
                textFieldCell.cellType = .ID
                return textFieldCell
            default:
                let textViewCell = DCreatTextViewCell.cellWith(tableView: tableView)
                textViewCell.textViewEndEditClosure = { [weak self] text in
                    self?.textViewCellEndEditAction(text: text)
                }
                return textViewCell
            }
        default:
            let cell = DCreatCell.cellWith(tableView: tableView)
            switch indexPath.row {
            case 0:
                cell.cellType = .type
            default:
                cell.cellType = .level
            }
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //套餐类型cell
        if indexPath == IndexPath.init(row: 0, section: 1) {
            let setTypeListVC = DCreatSetTypeViewController()
            setTypeListVC.cellSelectedClosure = { setTypeIndex in
                self.setTypeListVCCellSelectedAction(setType: setTypeIndex)
            }
            self.navigationController?.pushViewController(setTypeListVC, animated: true)
        }
        //套餐档位cell
        if indexPath == IndexPath.init(row: 1, section: 1) {
            setLevelListRequest()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 3 {
            return 136
        } else {
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "人工建单"
        //cancelButtonItem
        cancelButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        cancelButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .highlighted)
        navigationItem.leftBarButtonItem = cancelButtonItem
        //doneButtonItem
        doneButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        doneButtonItem.setTitleTextAttributes([NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : gray_CCCCCC], for: .disabled)
        doneButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    func setupDoneButton() {
        let isCompleted = !name.isEmpty && !phone.isEmpty && !ID.isEmpty && !address.isEmpty && !setType.isEmpty && !setLevelModel.plan_name.isEmpty
        doneButtonItem.isEnabled = isCompleted
    }
    
    //MARK: - Properties
    lazy var cancelButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelButtonAction))
    lazy var doneButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(doneButtonAction))

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: screenBounds, style: .grouped)
        tableView.backgroundColor = gray_F5F5F5
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var name = ""
    var phone = ""
    var ID = ""
    var address = ""
    var setType = ""
    var setLevelModel = DSetItemModel()
}
