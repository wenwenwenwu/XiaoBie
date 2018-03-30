//
//  CreatView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

//DCreatTextFieldCell
enum DCreatTextFieldCellType {
    case name
    case phone
    case ID
}
class DCreatTextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCreatTextFieldCell{
        let reuseIdentifier = "reatTextFieldCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCreatTextFieldCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCreatTextFieldCell
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldEndEditClosure(textField.text!, cellType)
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .right
        textField.font = font16
        textField.textColor = black_333333
        return textField
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var cellType: DCreatTextFieldCellType = .name {
        didSet {
            switch cellType {
            case .name:
                textField.attributedPlaceholder = NSAttributedString.init(string: "请输入姓名", attributes: [NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : gray_999999])
                textField.keyboardType = .default
                titleLabel.text = "客户姓名"
            case .phone:
                textField.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : gray_999999])
                textField.keyboardType = .phonePad
                titleLabel.text = "联系方式"
            case .ID:
                textField.attributedPlaceholder = NSAttributedString.init(string: "请输入身份证", attributes: [NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : gray_999999])
                textField.keyboardType = .namePhonePad
                titleLabel.text = "身份证号"
            }
        }
    }
    
    var textFieldEndEditClosure: (String, DCreatTextFieldCellType)->Void = {_,_ in }
}

//DCreatCell
enum DCreatCellType {
    case type
    case level
}
class DCreatCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(titleLabel)
        contentView.addSubview(pickLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCreatCell{
        let reuseIdentifier = "creatCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCreatCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCreatCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        pickLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-22)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var pickLabel: UILabel = {
        let label = UILabel()
        label.text = "请选择"
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_into"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var cellType: DCreatCellType = .type {
        didSet {
            switch cellType {
            case .type:
                titleLabel.text = "订单类型"
            case .level:
                titleLabel.text = "套餐档位"
            }
        }
    }
}

//DCreatTextViewCell
class DCreatTextViewCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(textView)
        contentView.addSubview(placeHolderLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCreatTextViewCell{
        let reuseIdentifier = "creatTextViewCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCreatTextViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCreatTextViewCell
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewEndEditClosure(textView.text)
    }
    
    //MARK: - Setup
    func setupFrame() {
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(14)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(placeHolderLabel).offset(-8)
            make.left.equalTo(placeHolderLabel).offset(-5)
            make.bottom.equalTo(-8)
            make.right.equalTo(-9)
        }
    }
    
    //MARK: - Properties
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "请填写详细地址，不小于5个字"
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = font16
        textView.textColor = black_333333
        return textView
    }()
    
    var textViewEndEditClosure: (String)->Void = {_ in }
}
