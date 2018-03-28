//
//  DCodeView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DCodeScanCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCodeScanCell{
        let reuseIdentifier = "scanCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCodeScanCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCodeScanCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        keyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.height.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(keyLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.text = "手机串号"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    var serialNumber = "" {
        didSet {
            valueLabel.text = serialNumber
        }
    }
    
}

class DCodeInputCodeCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueTextField)
        contentView.addSubview(codeButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCodeInputCodeCell{
        let reuseIdentifier = "inputCodeCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCodeInputCodeCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCodeInputCodeCell
    }
    
    //MARK: - Event Response
    @objc func codeButtonAction() {
        codeButtonClosure()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        code = textField.text!
        textField.resignFirstResponder()
    }
    
    //MARK: - Setup
    func setupFrame() {
        keyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.height.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(50)
        }
        
        valueTextField.snp.makeConstraints { (make) in
            make.left.equalTo(keyLabel.snp.right).offset(30)
            make.right.equalTo(codeButton.snp.left).offset(-30)
            make.centerY.equalToSuperview()
        }
        
        codeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.width.equalTo(61)
            make.height.equalTo(31)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.text = "发送验证码"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var valueTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString.init(string: "请输入验证码", attributes: [NSAttributedStringKey.font : font16, NSAttributedStringKey.foregroundColor : gray_999999])
        textField.font = font16
        textField.textColor = black_333333
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    lazy var codeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font12
        button.setTitle("验证码", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.addTarget(self, action: #selector(codeButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        return button
    }()
    
    var codeButtonClosure: ()->Void = { }
    var code = ""
    
    
    
}

class DCodeSectionHeaderCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(titleButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCodeSectionHeaderCell{
        let reuseIdentifier = "sectionHeaderCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCodeSectionHeaderCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCodeSectionHeaderCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleButton.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    lazy var titleButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isEnabled = false
        button.titleLabel?.font = font12
        button.setTitle("历史记录", for: .normal)
        button.setTitleColor(gray_5C6C94, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_down-blue"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 52, 0, -52)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        return button
    }()
}

class DCodeCodeCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(codeLabel)
        contentView.addSubview(timeLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DCodeCodeCell{
        let reuseIdentifier = "codeCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DCodeCodeCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DCodeCodeCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        codeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.height.equalTo(12)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    var model = DCodeItemModel() {
        didSet {
            codeLabel.text = "已发送验证码\(model.code)"
            timeLabel.text = DateTool.strDateToStrMDHM(strDate: model.create_time)
        }
    }
}
