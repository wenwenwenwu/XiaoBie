//
//  GrabView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class SelectView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = white_FFFFFF
        addSubview(stackView)
        addSubview(lineView)
        addSubview(slideView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(frame: CGRect, titleArray: [String], sliderWidth: CGFloat, buttonClosure: @escaping (Int)->Void) -> SelectView {
        let chanelView = SelectView.init(frame: frame)
        for item in 0..<titleArray.count {
            let button = UIButton.init(type: .custom)
            button.titleLabel?.font = font14
            button.setTitle(titleArray[item], for: .normal)
            button.setTitleColor(gray_666666, for: .normal)
            button.setTitleColor(blue_3296FA, for: .selected)
            button.isSelected = (item == 0)
            button.tag = item
            button.addTarget(chanelView, action: #selector(chanelButtonAction(_:)), for: .touchUpInside)
            chanelView.addSubview(button)
            chanelView.stackView.addArrangedSubview(button)
        }
        chanelView.sliderWidth = sliderWidth
        chanelView.buttonClosure = buttonClosure
        chanelView.setupFrame()//有了titleArray之后才能设置，因此放在这里
        return chanelView
    }
    
    //MARK: - Setup
    func setupFrame() {
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        slideView.snp.makeConstraints { (make) in
            let firstButton = stackView.arrangedSubviews[0]
            make.centerX.equalTo(firstButton)
            make.bottom.equalToSuperview()
            make.width.equalTo(self.sliderWidth)
            make.height.equalTo(2)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(screenWidth)
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Event Response
    @objc func chanelButtonAction(_ sender: UIButton) {
        //重新选中
        for item in stackView.arrangedSubviews {
            let button = item as! UIButton
            button.isSelected = false
        }
        sender.isSelected = true
        
        //滑动滑块
        UIView.animate(withDuration: animationTime) {
            self.slideView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(sender)
                make.bottom.equalToSuperview()
                make.width.equalTo(self.sliderWidth)
                make.height.equalTo(2)
            }
            self.layoutIfNeeded()
        }
        //closure
        buttonClosure(sender.tag)
    }
    
    //MARK: - Properties
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var slideView: UIView = {
        let view = UIView()
        view.backgroundColor = blue_3296FA
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var currentIndex = 0 {
        didSet {
            let button = stackView.arrangedSubviews[currentIndex] as! UIButton
            button.sendActions(for: UIControlEvents.touchUpInside)
        }
    }
    
    var buttonClosure: (Int)->Void = {_ in }
    
    var sliderWidth: CGFloat = 0
}
