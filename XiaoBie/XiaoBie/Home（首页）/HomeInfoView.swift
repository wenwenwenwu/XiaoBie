//
//  HomeInfoView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class HomeInfoCell: UIView {
    
    var value = "" {
        didSet{
            valueLabel.text = value
            setupFrame()
        }
    }
    
    
    lazy var imageView = UIImageView()
    
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font12
        label.textColor = gray_666666
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font14
        label.textColor = black_303133
        return label
    }()
    
    //MARK: - FactoryMethod
    class func cellWith(image: UIImage, key: String) -> HomeInfoCell{
        let view = HomeInfoCell.init(frame: CGRect.zero)
        view.imageView.image = image
        view.keyLabel.text = key
        return view
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(keyLabel)
        addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(36)
        }
        
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(keyLabel)
        stackView.addArrangedSubview(valueLabel)
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


class HomeInfoView: UIView {
    
    var model = HomeInfoModel() {
        didSet{
            self.cell1.value = model.original_order_count
            self.cell2.value = model.undone_order_count
            self.cell3.value = model.pay_money_today
            self.cell4.value = model.pay_money_total
            self.setupFrame()
        }
    }
    

    lazy var cell1 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_kqd"), key: "可抢单")
    lazy var cell2 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "未完成单")
    lazy var cell3 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_rjs"), key: "日结算")
    lazy var cell4 = HomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_zjs"), key: "总结算")
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 110))
        addSubview(cell1)
        addSubview(cell2)
        addSubview(cell3)
        addSubview(cell4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(cell1)
        stackView.addArrangedSubview(cell2)
        stackView.addArrangedSubview(cell3)
        stackView.addArrangedSubview(cell4)
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(15, 30, 15, 30))
        }
    }

}
