//
//  DToTestifyView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToTestifyInfoCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(costKeyLabel)
        contentView.addSubview(costValueLabel)
        contentView.addSubview(timeKeyLabel)
        contentView.addSubview(timeValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(setValueLabel)
        contentView.addSubview(addressKeyLabel)
        addressTextView.isEditable = false
        contentView.addSubview(addressTextView)
        contentView.addSubview(distanceImageView)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(noteKeyLabel)
        contentView.addSubview(noteValueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToTestifyInfoCell{
        let reuseIdentifier = "infoCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToTestifyInfoCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToTestifyInfoCell
    }
    
    //MARK: - Event Response
    @objc func editButtonAction() {
        if addressTextView.isEditable == false {
            addressTextView.isEditable = true
            addressTextView.isScrollEnabled = true
            addressTextView.becomeFirstResponder()
        }
    }

    
    //MARK: - Setup
    func setupFrame() {
        //key
        costKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(costValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        timeKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeValueLabel)
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
        
        addressKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        //value
        costValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(costKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        timeValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(costValueLabel.snp.bottom).offset(12)
            make.left.equalTo(timeKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(12)
            make.left.equalTo(phoneKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        setValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(12)
            make.left.equalTo(setKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        //addressTextView
        addressTextView.snp.makeConstraints { (make) in
            make.top.equalTo(setValueLabel.snp.bottom).offset(2)
            make.left.equalTo(83)
            make.right.equalTo(-67)
        }
        //distance
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(addressTextView.snp.bottom).offset(2)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.centerY.equalTo(distanceImageView)
        }        
        //note
        noteKeyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(noteValueLabel).offset(2)
            make.height.equalTo(model.remark.isEmpty ? 0 : 14)
        }
        noteValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTextView.snp.bottom).offset(model.remark.isEmpty ? 13 : 20)
            make.left.equalTo(addressTextView)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-17)
        }

    }
    
    //MARK: - Properties
    lazy var costKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "平均消费"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var costValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var timeKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "预约时间"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var timeValueLabel: UILabel = {
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
    
    lazy var addressKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "联系地址"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = font16
        textView.textColor = black_333333
        return textView
    }()
    
    lazy var distanceImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_dw"))
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = font10
        label.textColor = gray_999999
        return label
    }()
    
    lazy var noteKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "备注"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var noteValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    var model = DGrabItemModel() {
        didSet {
            costValueLabel.text = "\(model.average_cost)元"
            timeValueLabel.text = model.update_time
            phoneValueLabel.text = PhoneNumberTool.secret(phoneNumber: model.phone1)
            setValueLabel.text = model.gtcdw
            addressTextView.text = model.address
            noteValueLabel.text = model.remark
            //distanceLabel
            if model.distance == "-1" { //和后台约好返回的无法解析地址
                distanceImageView.isHidden = true
                distanceLabel.isHidden = true
            } else {
                distanceImageView.isHidden = false
                distanceLabel.isHidden = false
                distanceLabel.text = "距离：\(model.distanceKM)km"
            }
            setupFrame()

        }
    }
    
    var finishEditClosure: (DGrabItemModel)->Void = { _ in }
}

