//
//  DCheckedPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/14.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum DCheckedPopStatus: String {
    case isOrder = "0"
    case later = "1"
    case noReply = "2"
}

class DCheckedPopView: UIView {
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(baseView)
        baseView.addSubview(stackView)
        baseView.addSubview(submitButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func showPopViewWith(submitSuccessClosure:  @escaping (DCheckedPopStatus)->Void) {
        let popView = DCheckedPopView.init(frame: screenBounds)
        popView.submitSuccessClosure = submitSuccessClosure
        //动画
        UIView.animate(withDuration: animationTime) {
            popView.baseView.frame = CGRect.init(x: 0, y: screenHeight - popView.baseView.height, width: screenWidth, height: popView.baseView.height)
        }
        //加载
        UIApplication.shared.keyWindow?.addSubview(popView)
        
    }
    
    //MARK: - Event Response
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    @objc func statusButtonEvent(_ sender: UIButton) {
        let title: String! = sender.titleLabel?.text
        switch title {
        case "已预约"?:
            appointType = .isOrder
        case "再联系":
            appointType = .later
        default:
            appointType = .noReply
        }
        resetButtonStatus(button: sender)
    }
    
    @objc func submitButtonEvent() {
        submitSuccessClosure(appointType)
        dismiss()
    }
    
    //MARK: - Action Method
    func dismiss() {
        UIView.animate(withDuration: animationTime, animations: {
            self.baseView.frame = CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: self.baseView.height)
            self.backView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    func resetButtonStatus(button: UIButton) {
        orderButton.isSelected = false
        againButton.isSelected = false
        noButton.isSelected = false
        button.isSelected = true
    }
    
    //MARK: - Private Method
    func creatButton() -> UIButton{
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font14
        button.setTitleColor(gray_999999, for: UIControlState.normal)
        button.setTitleColor(white_FFFFFF, for: UIControlState.selected)
        button.setBackgroundImage(white_FFFFFF.colorImage(), for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .selected)
        button.layer.cornerRadius = 2
        button.layer.borderColor = gray_CCCCCC.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(statusButtonEvent(_:)), for: UIControlEvents.touchUpInside)
        return button
    }

    //MARK: - Setup
    func setupFrame() {
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(submitButton.snp.top).offset(-15)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.bottom.equalTo(-10)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Properties
    lazy var baseView: UIView = {
        let baseView = UIView()
        baseView.frame = CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: 120)
        baseView.backgroundColor = white_FFFFFF
        return baseView
    }()
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.frame = self.frame
        backView.backgroundColor = black_20
        return backView
    }()
    
    lazy var orderButton: UIButton = {
        let button = creatButton()
        button.setTitle("已预约", for: .normal)
        return button
    }()
    
    lazy var againButton: UIButton = {
        let button = creatButton()
        button.setTitle("再联系", for: .normal)
        return button
    }()
    
    lazy var noButton: UIButton = {
        let button = creatButton()
        button.setTitle("无人接听", for: .normal)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("提交", for: .normal)
        button.titleLabel?.font = font14
        button.setTitleColor(white_FFFFFF, for: UIControlState.normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitButtonEvent), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        orderButton.isSelected = true
        stackView.addArrangedSubview(orderButton)
        stackView.addArrangedSubview(againButton)
        stackView.addArrangedSubview(noButton)
        return stackView
    }()
    
    var submitSuccessClosure: (DCheckedPopStatus)->Void = {_ in }
    
    var appointType = DCheckedPopStatus.isOrder
}

