//
//  MyHeader.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MyHeader: UIView {

    var model = UserInfoModel() {
        didSet {
            //nameLabel
            nameLabel.text = AccountTool.userInfo().name
            //roundLabel
            let name = AccountTool.userInfo().name
            let rangeFirst = name.startIndex ... name.startIndex
            roundLabel.text = String(name[rangeFirst])
            //phoneLabel
            phoneLabel.text = AccountTool.userInfo().phone            
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 130))
        backgroundColor = white_FFFFFF
        addSubview(shadowView)
        shadowView.addSubview(nameLabel)
        shadowView.addSubview(roundLabel)
        shadowView.addSubview(phoneLabel)
        shadowView.addSubview(arrowView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup
    func setupFrame() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(17, 13, 5, 13))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(16)
        }
        
        roundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.right.equalTo(-16)
            make.width.height.equalTo(40)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.top.equalTo(nameLabel.snp.bottom).offset(26)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.left.equalTo(phoneLabel.snp.right).offset(5)
            make.centerY.equalTo(phoneLabel)
        }
    }
    
    //MARK: - Init
    lazy var shadowView = UIImageView.init(image: #imageLiteral(resourceName: "pic_di"))
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font18Medium
        label.textColor = black_333333
        return label
    }()
    
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font14
        label.textColor = white_FFFFFF
        label.backgroundColor = blue_3296FA
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var arrowView = UIImageView.init(image: #imageLiteral(resourceName: "icon_into"))
}
