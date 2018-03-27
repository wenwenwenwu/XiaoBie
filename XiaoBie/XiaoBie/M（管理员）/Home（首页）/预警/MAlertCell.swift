//
//  MAlertCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MAlertCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> MAlertCell{
        let reuseIdentifier = "alertCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = MAlertCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MAlertCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(idLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(thresholdLabel)
        contentView.addSubview(lineView)
        contentView.backgroundColor = white_FFFFFF
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        idLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(14)
            make.height.equalTo(15)
        }
        
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(45)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-14)
        }
        
        thresholdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-14)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = font16Medium
        label.textColor = black_333333
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = red_DC152C
        return label
    }()
    
    lazy var thresholdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font14
        label.textColor = gray_666666
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var model = MAlertItemModel() {
        didSet {
            idLabel.text = model.agent_id
            infoLabel.text = "昨天完成数:\(model.done1_count)  前天完成数:\(model.done2_count)  大前天完成数:\(model.done3_count)"
            thresholdLabel.text = "每日最低标准:\(model.threshold_count)"
        }
    }
}
