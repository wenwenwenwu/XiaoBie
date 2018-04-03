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
        contentView.addSubview(moneyKeyLabel)
        contentView.addSubview(moneyValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(setValueLabel)
        contentView.addSubview(addressKeyLabel)
        addressTextView.isEditable = false
        contentView.addSubview(addressTextView)
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
    
    //MARK: - Setup
    func setupFrame() {
        //key
        costKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(costValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        moneyKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(moneyValueLabel)
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
        
        moneyValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(costValueLabel.snp.bottom).offset(12)
            make.left.equalTo(moneyKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(moneyValueLabel.snp.bottom).offset(12)
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
        label.text = "平均话费"
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
    
    lazy var moneyKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "代收金额"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var moneyValueLabel: UILabel = {
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
            moneyValueLabel.text = "\(model.payment)（总价）"
            phoneValueLabel.text = PhoneNumberTool.secret(phoneNumber: model.phone1)
            setValueLabel.text = model.gtcdw
            addressTextView.text = model.address
            noteValueLabel.text = model.remark
            setupFrame()

        }
    }
}

enum CountDownButtonStatus {
    case disabledCounting
    case disabled
    case enabled
}

class CountDownButton: UIButton {
    
    private var countdownTimer: Timer?
    
    var status: CountDownButtonStatus = .disabled {
        didSet{
            switch status {
            case .disabledCounting:
                remainingSeconds = 30
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(timer:)), userInfo: nil, repeats: true)
                //用户交互动作不会影响计时器刷新了
                RunLoop.current.add(countdownTimer!, forMode: .commonModes)
                isEnabled = false
            case .disabled:
                countdownTimer?.invalidate()
                countdownTimer = nil
                setTitle("换人验单", for: .disabled)
                isEnabled = false
            case .enabled:
                countdownTimer?.invalidate()
                countdownTimer = nil
                setTitle("换人验单", for: .normal)
                isEnabled = true
            }
            changeStatusClosure(status)
        }
    }
    
    var changeStatusClosure: (CountDownButtonStatus)->Void = {_ in }
        
    private var remainingSeconds: Int = 0 {
        willSet {
            setTitle("等待做单员答复(\(newValue))", for: .normal)            
            if newValue <= 0 {
                status = .enabled
            }
        }
    }
    
    @objc private func updateTime(timer: Timer) {
        remainingSeconds -= 1
    }
}


