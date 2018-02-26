//
//  MyMoneyView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MyMoneyInfoView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = white_FFFFFF
        addSubview(cell1)
        addSubview(cell2)
        addSubview(cell3)
        addSubview(grayView)
        grayView.addSubview(infoLabel)
        grayView.addSubview(calendarButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(cell1)
        stackView.addArrangedSubview(cell2)
        stackView.addArrangedSubview(cell3)
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(grayView.snp.top)
        }
        
        grayView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        calendarButton.snp.makeConstraints { (make) in
            make.right.equalTo(-11)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Event Response
    @objc func calendarButtonAction() {
        calendarButtonClosure()
    }
    
    //MARK: - Properties
    lazy var cell1 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_rjs"), key: "日结算")
    lazy var cell2 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_zjs"), key: "总结算")
    lazy var cell3 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "罚款")
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    lazy var infoLabel: UILabel = {
       let label = UILabel()
        label.text = "收益详情"
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "icon_rl"), for: .normal)
        button.addTarget(self, action: #selector(calendarButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = MyMoneyInfoModel() {
        didSet{
            self.cell1.valueLabel.text = "¥\(model.today_pay_money)"
            self.cell2.valueLabel.text = "¥\(model.total_pay_money)"
            self.cell3.valueLabel.text = "¥\(model.punish_money)"
        }
    }
    
    var calendarButtonClosure: ()->Void = {}
}

