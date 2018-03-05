//
//  DHomeInfoView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DHomeInfoCell: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(keyLabel)
        addSubview(valueLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(image: UIImage, key: String) -> DHomeInfoCell{
        let view = DHomeInfoCell.init(frame: CGRect.zero)
        view.imageView.image = image
        view.keyLabel.text = key
        return view
    }
    
    //MARK: - Setup
    func setupFrame() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        keyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(keyLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(11)
        }
    }
    
    //MARK: - Properties
    lazy var imageView = UIImageView()
    
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font12
        label.textColor = gray_666666
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font14
        label.textColor = black_303133
        return label
    }()
    
}


class DHomeInfoView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = white_FFFFFF
        addSubview(cell1)
        addSubview(cell2)
        addSubview(cell3)
        addSubview(grayView)
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
            make.edges.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(11)
        }
    }
    
    //MARK: - Properties
    lazy var cell1 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_kqd"), key: "可抢单")
    lazy var cell2 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "未完成单")
    lazy var cell3 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_rjs"), key: "日结算")
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var model = DHomeInfoModel() {
        didSet{
            self.cell1.valueLabel.text = model.original_order_count
            self.cell2.valueLabel.text = model.undone_order_count
            self.cell3.valueLabel.text = "¥\(model.pay_money_today)"
        }
    }
}
