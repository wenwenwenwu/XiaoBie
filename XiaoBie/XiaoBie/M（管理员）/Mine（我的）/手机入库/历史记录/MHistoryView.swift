//
//  MHistoryView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MHistorySourceView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = gray_F5F5F5
        addSubview(sourceLabel)
        addSubview(arrowImageView)
        addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(sourceLabelTapClosure: @escaping ()->Void) -> MHistorySourceView {
        let view = MHistorySourceView()
        view.sourceLabelTapClosure = sourceLabelTapClosure
        return view
    }
    
    //MARK: - Action
    @objc func sourceLabelTapAction() {
        sourceLabelTapClosure()
    }
    
    //MARK: - Setup
    func setupFrame() {
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.bottom.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalTo(sourceLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "来源源自于青藏高原"
        label.textColor = black_333333
        label.font = font14
        //添加点击手势
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(sourceLabelTapAction))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_xjt_default"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_E5E5E5
        return view
    }()
    
    var sourceLabelTapClosure: ()->Void = {}
        
    var sourceName = "" {
        didSet{
            sourceLabel.text = sourceName
        }
    }
}

