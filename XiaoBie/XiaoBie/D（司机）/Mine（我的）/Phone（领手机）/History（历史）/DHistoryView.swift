//
//  DHistoryCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/23.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DHistoryCell: UITableViewCell {

    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DHistoryCell{
        let reuseIdentifier = "historyCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DHistoryCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DHistoryCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(14)
            make.height.equalTo(12)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.right.equalTo(-14)
            make.height.equalTo(9)
        }
        
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.height.equalTo(13)
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "手机串号"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var model = DHistoryModel() {
        didSet {
            //dateLabel
            dateLabel.text = DateTool.strDateToStr年月日(strDate: model.update_time)
            //numberLabel
            numberLabel.text = model.serial_no
        }
    }    
}

class DHistoryDateView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = gray_F5F5F5
        addSubview(dateLabel)
        addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setupDate(startDate: String, endDate: String) {
        dateLabel.text = "\(startDate)  至  \(endDate)"
    }
    
    //MARK: - Properties
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = black_333333
        label.font = font14
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_E5E5E5
        return view
    }()
}
