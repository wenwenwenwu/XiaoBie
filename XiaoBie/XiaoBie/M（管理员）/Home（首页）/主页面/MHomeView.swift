//
//  MHomeView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MHomeInfoView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        addSubview(grayView)
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
    lazy var cell1 = MHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_kqd"), key1: "已完成:", key2: "未完成:")
    
    lazy var cell2 = MHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_qianbao"), key1: "已交帐:", key2: "未交帐:")
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView.init(frame: frame)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(cell1)
        stackView.addArrangedSubview(cell2)
        return stackView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var model = MHomeInfoModel() {
        didSet{
            self.cell1.value1Label.text = "\(model.complete_order_count)(单)"
            self.cell1.value2Label.text = "\(model.undone_order_count)(单)"
            self.cell2.value1Label.text = "\(model.total_pay)(元)"
            self.cell2.value2Label.text = "\(model.total_unpay)(元)"
        }
    }
}

class MHomeInfoCell: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(stackView1)
        addSubview(stackView2)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(image: UIImage, key1: String, key2: String) -> MHomeInfoCell{
        let view = MHomeInfoCell.init(frame: CGRect.zero)
        view.imageView.image = image
        view.key1Label.text = key1
        view.key2Label.text = key2
        
        return view
    }
    
    //MARK: - Setup
    func setupFrame() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
        }
        
        stackView1.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        stackView2.snp.makeConstraints { (make) in
            make.top.equalTo(stackView1.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
    }
    
    //MARK: - Properties
    lazy var imageView = UIImageView()
    
    lazy var key1Label: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_666666
        return label
    }()
    
    lazy var key2Label: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_666666
        return label
    }()
    
    lazy var value1Label: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textColor = black_303133
        return label
    }()
    
    lazy var value2Label: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textColor = black_303133
        return label
    }()
    
    lazy var stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(key1Label)
        stackView.addArrangedSubview(value1Label)
        return stackView
    }()
    
    lazy var stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(key2Label)
        stackView.addArrangedSubview(value2Label)
        return stackView
    }()
}
