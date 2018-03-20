//
//  CHomeView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CHomeInfoView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        addSubview(grayView)
        
        backgroundColor = white_FFFFFF
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        stackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(grayView.snp.top)
        }
        
        grayView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(11)
        }
    }
    
    //MARK: - Properties
    lazy var cell1 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_kqd"), key: "今日完成")
    lazy var cell2 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "本月完成")
    lazy var cell3 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "待付金额")
    lazy var cell4 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_rjs"), key: "需交总费用")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(cell1)
        stackView.addArrangedSubview(cell2)
        stackView.addArrangedSubview(cell3)
        stackView.addArrangedSubview(cell4)
        return stackView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var model = CHomeInfoModel() {
        didSet{
            self.cell1.valueLabel.text = model.totay_count
            self.cell2.valueLabel.text = model.month_count
            self.cell3.valueLabel.text = "¥\(model.payment)"
            self.cell4.valueLabel.text = "¥\(model.valuation)"
        }
    }
}

