//
//  MHistoryView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class IHistorySourceView: UIView {
    
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
    class func viewWith(sourceLabelTapClosure: @escaping ()->Void) -> IHistorySourceView {
        let view = IHistorySourceView()
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
        label.text = "请选择来源"
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

class MHistoryCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> MHistoryCell{
        let reuseIdentifier = "historyCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = MHistoryCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MHistoryCell
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
        
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(nameLabel.snp.left).offset(-5)
            make.centerY.equalTo(nameLabel)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(11)
            make.right.equalTo(-16)
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
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "入库: "
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var nameLabel: UILabel = {
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
            //nameLabel
            nameLabel.text = "小明"
        }
    }
}

