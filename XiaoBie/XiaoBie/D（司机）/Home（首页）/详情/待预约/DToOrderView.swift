//
//  DToOrderView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToOrderInfoCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(nameKeyLabel)
        contentView.addSubview(nameValueLabel)
        contentView.addSubview(timeKeyLabel)
        contentView.addSubview(timeValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(addressKeyLabel)
        addressTextView.isEditable = false
        contentView.addSubview(addressTextView)
        contentView.addSubview(distanceImageView)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(editButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToOrderInfoCell{
        let reuseIdentifier = "infoCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToOrderInfoCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToOrderInfoCell
    }
    
    //MARK: - Event Response
    @objc func editButtonAction() {
        if addressTextView.isEditable == false {
            addressTextView.isEditable = true
            addressTextView.isScrollEnabled = true
            addressTextView.becomeFirstResponder()
        }
    }
    
    //MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {//回车
            textView.resignFirstResponder()
            textView.isEditable = false
            textView.isScrollEnabled = false
            finishEditClosure(textView.text)
        }
        return true
    }
    
    //MARK: - Setup
    func setupFrame() {
        //key
        nameKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameValueLabel)
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
        
        addressKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        //value
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(nameKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        timeValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(12)
            make.left.equalTo(timeKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(12)
            make.left.equalTo(phoneKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }        
        //addressTextView
        addressTextView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(2)
            make.left.equalTo(83)
            make.right.equalTo(-67)
            make.bottom.equalTo(-32)
        }
        //distance
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(85)
            make.bottom.equalTo(-14)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.centerY.equalTo(distanceImageView)
        }
        //editButton
        editButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.top.equalTo(addressKeyLabel)
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
    
    lazy var timeKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "订单时间"
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
        textView.returnKeyType = .done
        textView.delegate = self
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
            timeValueLabel.text = model.update_time
            phoneValueLabel.text = model.phone1
            addressTextView.text = model.address
            //distanceLabel
            if model.distance == "-1" { //和后台约好返回的无法解析地址
                distanceImageView.isHidden = true
                distanceLabel.isHidden = true
            } else {
                distanceImageView.isHidden = false
                distanceLabel.isHidden = false
                distanceLabel.text = "距离：\(model.distanceKM)km"
            }
            
        }
    }
    
    var finishEditClosure: (String)->Void = { _ in }
}

class DToOrderSetPickCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(infoLabel)
        contentView.addSubview(pickLabel)
        contentView.addSubview(arrowImageView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToOrderSetPickCell{
        let reuseIdentifier = "setPickCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToCheckScanCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToOrderSetPickCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.height.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        pickLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "套餐档位"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var pickLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_into"))
}
