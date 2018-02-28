//
//  MyMoneyView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/26.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DMyMoneyCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DMyMoneyCell{
        let reuseIdentifier = "myMoneyCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DMyMoneyCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DMyMoneyCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(whiteView)
        whiteView.addSubview(timeLabel)
        whiteView.addSubview(moneyLabel)
        whiteView.addSubview(lineView)
        whiteView.addSubview(iconImageView)
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(addressLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 11, 0))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.height.equalTo(13)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(timeLabel)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(35)
            make.right.equalTo(-13)
            make.height.equalTo(2)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(lineView.snp.bottom).offset(9)
            make.width.equalTo(61)
            make.height.equalTo(61)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.height.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.right.equalTo(-26)
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
        }
    }
    
    //MARK: - Properties
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textColor = red_DC152C
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    lazy var iconImageView = UIImageView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = font16Medium
        label.textColor = black_333333
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font14
        label.textColor = gray_666666
        return label
    }()
    
    var model = DMyMoneyItemModel() {
        didSet {
            timeLabel.text = DateTool.strDateToStr月日时分(strDate: model.create_time)
            iconImageView.image = (model.project_type == "0") ? #imageLiteral(resourceName: "icon_phone") : #imageLiteral(resourceName: "icon_ll")
            nameLabel.text = model.user_name
            addressLabel.text = model.address
            moneyLabel.text = "+\(model.reward)"
        }
    }
}

class DMyMoneyInfoView: UIView {
    
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
    lazy var cell1 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_rjs"), key: "日结算")
    lazy var cell2 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_zjs"), key: "总结算")
    lazy var cell3 = DHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_wwc"), key: "罚款")
    
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
    
    var model = DMyMoneyInfoModel() {
        didSet{
            self.cell1.valueLabel.text = "¥\(model.today_pay_money)"
            self.cell2.valueLabel.text = "¥\(model.total_pay_money)"
            self.cell3.valueLabel.text = "¥\(model.punish_money)"
        }
    }
    
    var calendarButtonClosure: ()->Void = {}
}

