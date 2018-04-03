//
//  ModifyUserView.swift
//  PostOfficeAdmain
//
//  Created by wuwenwen on 2017/9/12.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit


class MDatePickView: UIView{
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(baseView)
        baseView.addSubview(datePickerView)
        baseView.addSubview(lineViewTop)
        baseView.addSubview(lineViewMiddle)
        baseView.addSubview(cancelButton)
        baseView.addSubview(returnButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(selectedClosure: @escaping (String)->Void) {
        self.init(frame: screenBounds)
        datePickerView.date = Date()
        self.selectedClosure = selectedClosure
    }
    
    //MARK:Action
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    @objc func cancelButtonAction() {
        dismiss()
    }
    
    @objc func returnButtonAction() {
        dismiss()        
        selectedClosure(DateTool.dateToStrDate(date: datePickerView.date))
    }
    
    //MARK: - Action Method
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.backView.alpha = 1
        UIView.animate(withDuration: animationTime) {
            self.baseView.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(self.datePickerView.height+45)
            })
            self.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: animationTime, animations: {
            self.baseView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.backView.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(self.datePickerView.height+45)
            })
            self.layoutIfNeeded()
            self.backView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            
        }
    }
    
    //MARK: - Setup
    func setupFrame() {
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        baseView.snp.makeConstraints { (make) in
            make.top.equalTo(backView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(datePickerView.height+45)
        }
        
        lineViewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        lineViewMiddle.snp.makeConstraints { (make) in
            make.top.equalTo(45)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(100)
            make.bottom.equalTo(lineViewMiddle)
        }
        
        returnButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.equalTo(100)
            make.bottom.equalTo(lineViewMiddle)
        }
        
        datePickerView.snp.makeConstraints { (make) in
            make.top.equalTo(lineViewMiddle)
            make.left.right.bottom.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    //MARK: - Properties
    lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.backgroundColor = white_FFFFFF
        datePickerView.locale = NSLocale.init(localeIdentifier: "zh-CN") as Locale
        datePickerView.datePickerMode = UIDatePickerMode.date
        return datePickerView
    }()
    
    lazy var baseView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = white_FFFFFF
        return baseView
    }()
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = black_20
        return backView
    }()
    
    lazy var lineViewTop: UIView = {
        let lineViewTop = UIView()
        lineViewTop.backgroundColor = gray_F0F0F0
        return lineViewTop
    }()
    
    lazy var lineViewMiddle: UIView = {
        let lineViewMiddle = UIView()
        lineViewMiddle.backgroundColor = gray_F0F0F0
        return lineViewMiddle
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.left
        cancelButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(gray_666666, for: UIControlState.normal)
        cancelButton.titleLabel?.font = font16
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        return cancelButton
    }()
    
    lazy var returnButton: UIButton = {
        let returnButton = UIButton.init(type: .custom)
        returnButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.right
        returnButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15)
        returnButton.setTitle("确定", for: .normal)
        returnButton.setTitleColor(blue_3296FA, for: UIControlState.normal)
        returnButton.titleLabel?.font = font16
        returnButton.addTarget(self, action: #selector(returnButtonAction), for: UIControlEvents.touchUpInside)
        return returnButton
    }()
    
    var selectedClosure: (String)->Void = {_ in }
    var currentDate = ""
}
