//
//  CalendarView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/24.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DateView: UIView {

    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(isSelected: Bool, date: String, closure: @escaping (Bool)->Void) -> DateView {
        let view = DateView()
        view.isSelected = isSelected
        view.date = date
        view.dateButtonClosure = closure
        return view
    }
    
    //MARK: - Setup
    func setupFrame() {
        dateLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    //MARK: - Event Response
    @objc func tapAction() {
        if isSelected == false {
            isSelected = true
        }
    }
    
    //MARK: - Properties
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font14
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
        
    var dateButtonClosure: (Bool)->Void = {_ in }
    
    var date  = "" {
        didSet{
            dateLabel.text = date
        }
    }
    
    var isSelected = false {
        didSet{
            if isSelected {
                dateLabel.textColor = blue_3296FA
                lineView.backgroundColor = blue_3296FA
            } else {
                dateLabel.textColor = black_333333
                lineView.backgroundColor = gray_CCCCCC
            }
            dateButtonClosure(isSelected)
        }
        
        
    }
    
}
