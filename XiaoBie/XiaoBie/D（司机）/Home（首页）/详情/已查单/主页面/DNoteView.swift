//
//  DCheckedPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/5.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DNoteView: UIView, UITextViewDelegate{
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(baseView)
        baseView.addSubview(infoLabel)
        baseView.addSubview(textView)
        baseView.addSubview(placeHolderLabel)
        baseView.addSubview(submitButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func showNoteView(submitClosure: @escaping (String)->Void) {
        let view = DNoteView.init(frame: screenBounds)
        UIView.animate(withDuration: animationTime) {
            view.baseView.frame = CGRect.init(x: 0, y: screenHeight-view.baseView.height, width: view.baseView.width, height: view.baseView.height)
        }
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    //MARK: - Event Response
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    @objc func cancelButtonAction() {
        dismiss()
    }
    
    @objc func submitButtonAction() {
        dismiss()
        submitButtonClosure(textView.text)
    }
    
    //MARK: - Private Method
    func dismiss() {
        UIView.animate(withDuration: animationTime, animations: {
            self.baseView.frame = CGRect.init(x: 0, y: screenHeight, width: self.baseView.width, height: self.baseView.height)
            self.backView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    
    //MARK: - Setup
    func setupFrame() {
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(13)
            make.height.equalTo(14)
        }
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(5)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(7)
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
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
        let baseView = UIView.init(frame: CGRect.init(x: 0, y: screenHeight, width: screenWidth, height: 200))
        baseView.backgroundColor = white_FFFFFF
        return baseView
    }()
    
    lazy var backView: UIView = {
        let backView = UIView.init(frame: screenBounds)
        backView.backgroundColor = black_20
        return backView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "备注"
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "写点什么吧..."
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.red
        textView.delegate = self
        textView.font = font14
        textView.textColor = black_333333
        return textView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("提交", for: .normal)
        button.setTitleColor(white_FFFFFF, for: UIControlState.normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitButtonAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    var submitButtonClosure: (String)->Void = { String in }
}

