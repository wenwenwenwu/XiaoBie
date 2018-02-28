//
//  LoginCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum LoginnCellType {
    case phone
    case password
}

class LoginCell: UIView, UITextFieldDelegate {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        addSubview(eyeButton)
        addSubview(clearButton)
        addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func cellWith(type: LoginnCellType) -> LoginCell {
        let cell = LoginCell()
        cell.type = type
        return cell
    }
    
    //MARK: - Setup
    func setupFrame() {
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(eyeButton.snp.left).offset(-15)
            make.centerY.equalTo(textField)
        }

        eyeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(textField)
        }
        
    }
    
    //MARK: - Event Response
    @objc func clearButtonAction() {
        textField.text = ""
        clearButton.isHidden = true
    }
    @objc func eyeButtonAction() {
        eyeButton.isSelected = !eyeButton.isSelected
        textField.isSecureTextEntry = !eyeButton.isSelected
    }
    
    //MARK: - 监听输入
    @objc func textFieldDidChange(sender: UITextField) {
        //clearButton
        clearButton.isHidden = (textField.text?.count == 0)
        //字数限制
        if textField.text!.count > 20 {
            HudTool.showInfo(string: "密码只能是6-20位的字母数字")
            let tempStr = NSString.init(string: textField.text!)
            textField.text = tempStr.substring(to: 20)
        }
    }
    
    //MARK: - Properties
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = font16
        textField.textColor = black_333333
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        return textField
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = gray_CCCCCC
        return lineView
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_cha"), for: .normal)
        button.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var eyeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_biyan"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_zhengyan"), for: .selected)
        button.addTarget(self, action: #selector(eyeButtonAction), for: .touchUpInside)
        return button
    }()
    
    var type: LoginnCellType = .phone {
        didSet{
            switch type {
            case .phone:
                //textField
                textField.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedStringKey.foregroundColor : gray_999999, NSAttributedStringKey.font: font16])
                textField.keyboardType = .phonePad
                //eyeButton
                eyeButton.isHidden = true
                //clearButton
                clearButton.isHidden = true
            default:
                //textField
                textField.attributedPlaceholder = NSAttributedString.init(string: "请输入密码", attributes: [NSAttributedStringKey.foregroundColor : gray_999999, NSAttributedStringKey.font: font16])
                textField.keyboardType = .asciiCapable
                textField.isSecureTextEntry = true
                //eyeButton
                eyeButton.isHidden = false
                //clearButton
                clearButton.isHidden = true
            }
        }
    }
    
}
