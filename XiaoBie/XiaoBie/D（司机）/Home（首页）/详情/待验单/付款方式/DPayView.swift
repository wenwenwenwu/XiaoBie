//
//  DPayView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum PayMethod {
    
    case zhifubao
    case weixin
    case cash
}

class DPayMoneyCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(titleLabel)
        contentView.addSubview(moneyTextField)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DPayMoneyCell{
        let reuseIdentifier = "payMoneyCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DPayMoneyCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DPayMoneyCell
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        payMoney = textField.text!
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(15)
            make.height.equalTo(12)
            
        }
        
        symbolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(titleLabel.snp.bottom).offset(46)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        moneyTextField.snp.makeConstraints { (make) in
            make.left.equalTo(symbolLabel.snp.right).offset(9)
            make.bottom.equalTo(symbolLabel)
            make.right.equalTo(-13)
            make.height.equalTo(38)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(96)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(1)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalTo(14)
            make.height.equalTo(12)
        }
        
    }
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "实收金额"
        label.font = font12
        label.textColor = black_333333
        return label
    }()
    
    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "￥"
        label.font = font20Medium
        label.textColor = black_333333
        return label
    }()
    
    lazy var moneyTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.font = font50Medium
        textField.textColor = black_333333
        return textField
    }()
    
    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "注：可填0元，但只能选择现金收款"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var payMoney = ""
}

class DPayMethodCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(payMethodImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectButton)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DPayMethodCell{
        let reuseIdentifier = "payMethodCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DPayMethodCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DPayMethodCell
    }
    
    //MARK: - Setup
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectButton.isSelected = selected
    }
    
    func setupFrame() {
        payMethodImageView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(payMethodImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var payMethodImageView = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(#imageLiteral(resourceName: "icon_g_selected"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "icon_g_default"), for: .normal)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var payMethod: PayMethod = .zhifubao {
        didSet {
            switch payMethod {
            case .zhifubao:
                payMethodImageView.image = #imageLiteral(resourceName: "icon_zfb")
                titleLabel.text = "支付宝"
            case .weixin:
                payMethodImageView.image = #imageLiteral(resourceName: "icon_wchat")
                titleLabel.text = "微信"
            case .cash:
                payMethodImageView.image = #imageLiteral(resourceName: "icon_cash")
                titleLabel.text = "现金"
            }
        }    
    }
}

