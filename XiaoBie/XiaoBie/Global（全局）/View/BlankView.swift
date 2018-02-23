//
//  blankView.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/30.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

enum ViewType {
    case noData
    case noWeb
}

class BlankView: UIView {
    
    var buttonClosure: ()->Void = {}
    
    var viewType: ViewType? {
        didSet{
            switch viewType {
            case .noData?:
                self.imageView.image = #imageLiteral(resourceName: "pic_nothing")
                self.button.setTitle("抱歉，暂时没有数据...", for: .normal)
            case .noWeb?:
                self.imageView.image = #imageLiteral(resourceName: "pic_nowifi")
                self.button.setTitle("没有网络点击刷新", for: .normal)
            default:
                self.imageView.image = nil
            }
        }
    }
    
    lazy var imageView = UIImageView()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font14
        button.setTitleColor(gray_999999, for: .normal)
        button.contentVerticalAlignment = .top
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = gray_F5F5F5
        addSubview(imageView)
        addSubview(button)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(-10)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Action
    @objc func buttonAction() {
        buttonClosure()
    }
}
