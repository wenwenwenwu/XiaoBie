//
//  CToTestifyInfoCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/29.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CToTestifyInfoCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(nameKeyLabel)
        contentView.addSubview(nameValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(setValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(numberKeyLabel)
        contentView.addSubview(numberValueLabel)
        contentView.addSubview(noteKeyLabel)
        noteTextView.isEditable = false
        contentView.addSubview(noteTextView)
        contentView.addSubview(editButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> CToTestifyInfoCell{
        let reuseIdentifier = "infoCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = CToTestifyInfoCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! CToTestifyInfoCell
    }
    
    //MARK: - Event Response
    @objc func editButtonAction() {
        if noteTextView.isEditable == false {
            noteTextView.isEditable = true
            noteTextView.becomeFirstResponder()
        }
    }
    
    //MARK: - Request
    func updateNoteRequest() {
        WebTool.post(uri:"change_remark", para:["order_id": model.id, "remark": noteTextView.text!], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            self.noteTextView.isEditable = false
            HudTool.showInfo(string: model.msg)
        }) { (error) in
            self.noteTextView.isEditable = false
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        updateNoteRequest()
    }
    
    //MARK: - Setup
    func setupFrame() {
        //key
        nameKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        phoneKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        setKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(setValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        numberKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        noteKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numberKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        //value
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(nameKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(12)
            make.left.equalTo(phoneKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        setValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(12)
            make.left.equalTo(setKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        numberValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setValueLabel.snp.bottom).offset(12)
            make.left.equalTo(numberKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        //noteTextView
        noteTextView.snp.makeConstraints { (make) in
            make.top.equalTo(numberValueLabel.snp.bottom).offset(2)
            make.left.equalTo(83)
            make.right.equalTo(-67)
            make.height.equalTo(40)
            make.bottom.equalTo(-22)
        }

        //editButton
        editButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.top.equalTo(noteKeyLabel)
        }
    }
    
    //MARK: - Properties
    lazy var nameKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "客户姓名"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var nameValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var phoneKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "联系方式"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var phoneValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var setKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "套餐档位"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var setValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var numberKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "手机串号"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var numberValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = blue_3899F7
        return label
    }()
    
    lazy var noteKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "备注信息"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = font14
        textView.textColor = black_333333
        return textView
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_bj"), for: .normal)
        button.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel() {
        didSet {
            nameValueLabel.text = model.user_name
            phoneValueLabel.text = model.phone1
            setValueLabel.text = model.gtcdw
            numberValueLabel.text = model.serial_no
            noteTextView.text = model.remark
        }
    }
}
