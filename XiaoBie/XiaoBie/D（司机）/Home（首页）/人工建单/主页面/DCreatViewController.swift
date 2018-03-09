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
        
    }
    
    func textFieldCellEditedAction(text: String, cellType: DCreatTextFieldCellType ) {
        switch cellType {
        case .name:
            name = text
        case .phone:
            phone = text
        case .ID:
            ID = text
        }
        infomationChanged()
    }
    
    func textViewCellEditedAction(text: String) {
        address = text
        infomationChanged()
    }
    
    func setTypeCellAction()  {
        let setLevelListVC = DCreatSetTypeViewController()
        setLevelListVC.editedClosure = { setTypeIndex in
            self.setTypeListVCEditedAction(setType: setTypeIndex)
        }
        self.navigationController?.pushViewController(setLevelListVC, animated: true)
    }
    
    func setLevelCellAction() {
        setLevelListRequest()
    }
    
    func setLevelListVCEditedAction(setLevel: String)  {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1)) as! DCreatCell
        cell.pickLabel.text = setLevel
        self.setLevel = setLevel
        infomationChanged()
    }
    
    func setTypeListVCEditedAction(setType: String)  {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! DCreatCell
        cell.pickLabel.text = setType
        if setType == "手机" {
            self.setType = "0"
        } else {
            self.setType = "1"

        }
        infomationChanged()
    }
    
    func infomationChanged()  {
        guard !name.isEmpty && !phone.isEmpty && !ID.isEmpty && !address.isEmpty && !setType.isEmpty && !setLevel.isEmpty else {
            return
        }
        doneButtonItem.isEnabled = true
    }
    
    //MARK: - Request
    func setLevelListRequest() {
        WebTool.get(uri:"query_plan_type", para:[:], success: { (dict) in
            let model = DSetListResponseModel.parse(dict: dict)
            if model.code == "0" {
                let setLevelListVC = DCreatSetLevelViewController()
                setLevelListVC.dataArray = model.data
                setLevelListVC.editedClosure = { setItemModel in
                    self.setLevelListVCEditedAction(setLevel: setItemModel.plan_name)
                }
                self.navigationController?.pushViewController(setLevelListVC, animated: true)
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
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let textFieldCell = DCreatTextFieldCell.cellWith(tableView: tableView)
            textFieldCell.editedClosure = { [weak self] text, cellType in
                self?.textFieldCellEditedAction(text: text, cellType: cellType)
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
                textViewCell.editedClosure = { [weak self] text in
                    self?.textViewCellEditedAction(text: text)
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
    
    //MARK: - UITableViewDataSource
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
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //套餐类型
        if indexPath == IndexPath.init(row: 0, section: 1) {
            setTypeCellAction()
        }
        //套餐档位
        if indexPath == IndexPath.init(row: 1, section: 1) {
            setLevelCellAction()
        }
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
    var setLevel = ""
}
