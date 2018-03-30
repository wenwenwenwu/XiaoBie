//
//  MCompleteView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/21.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CCompleteInfoCell: UITableViewCell {
    
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
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> CCompleteInfoCell{
        let reuseIdentifier = "infoCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = CCompleteInfoCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! CCompleteInfoCell
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
            make.top.equalTo(setValueLabel.snp.bottom).offset(11)
            make.left.equalTo(numberKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
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
    
    var model = DGrabItemModel() {
        didSet {
            nameValueLabel.text = model.user_name
            phoneValueLabel.text = model.phone1
            setValueLabel.text = model.gtcdw
            numberValueLabel.text = model.serial_no            
        }
    }
}
