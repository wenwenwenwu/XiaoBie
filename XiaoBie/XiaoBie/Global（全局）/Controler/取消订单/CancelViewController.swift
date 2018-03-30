//
//  CancelViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/30.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CancelViewController: UIViewController,UITextViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        view.addSubview(placeHolderLabel)
        view.addSubview(confirmButton)
        
        navigationItem.title = "取消订单"
        view.backgroundColor = gray_F5F5F5
        setupFrame()
    }
    
    //MARK: - Action
    @objc func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonAction() {
        textView.resignFirstResponder()
        confirmButtonClosure(textView.text)
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
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(40)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
        
    }
    
    //MARK: - Properties
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "请填写取消原因"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = font14
        textView.textColor = black_333333
        return textView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font14
        button.setTitle("确定取消", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    var confirmButtonClosure: (String)->Void = {_ in }
}
