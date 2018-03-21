//
//  MAddView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/21.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CToTestifyCodeCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(sendButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> CToTestifyCodeCell{
        let reuseIdentifier = "codeCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = CToTestifyCodeCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! CToTestifyCodeCell
    }
    
    //MARK: - Action
    @objc func sendButtonAction() {
        sendButtonClosure()
    }
    
    //MARK: - Setup
    func setupFrame() {
        keyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(keyLabel.snp.right).offset(30)
            make.centerY.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(30)
        }        
    }
    
    //MARK: - Properties
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.text = "验证码"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font12
        button.setTitle("提醒发送", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return button
    }()
    
    var sendButtonClosure: ()->Void = {}
    
    var code = "" {
        didSet {
            valueLabel.text = code
        }
    }
    
   
}
