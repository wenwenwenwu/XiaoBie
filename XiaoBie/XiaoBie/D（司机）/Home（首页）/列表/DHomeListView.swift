//
//  DHomeListCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DHomeListCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DHomeListCell{
        let reuseIdentifier = "homeListCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DHomeListCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DHomeListCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(whiteView)
        whiteView.addSubview(timeLabel)
        whiteView.addSubview(statusLabel)
        whiteView.addSubview(lineView)
        whiteView.addSubview(iconImageView)
        whiteView.addSubview(costLabel)
        whiteView.addSubview(addressLabel)
        whiteView.addSubview(distanceImageView)
        whiteView.addSubview(distanceLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(13, 13, 0, 13))
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(11)
            make.left.height.equalTo(13)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.centerY.equalTo(timeLabel)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(34)
            make.right.equalTo(-13)
            make.height.equalTo(1)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        costLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.right.equalTo(-15)
            make.top.equalTo(costLabel.snp.bottom).offset(7)
        }
        
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.centerY.equalTo(distanceLabel)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.height.equalTo(10)
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
    
    lazy var statusLabel: UILabel = {
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
    
    lazy var costLabel: UILabel = {
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
    
    lazy var distanceImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_dw"))
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = font10
        label.textColor = gray_999999
        return label
    }()
    
    var model = DGrabItemModel() {
        didSet {
            //timeLabel
            timeLabel.text = DateTool.strDateToStr月日时分(strDate: model.update_time)
            //iconImageView
            iconImageView.image = (model.project_type == "0") ? #imageLiteral(resourceName: "icon_phone") : #imageLiteral(resourceName: "icon_ll")
            //costLabel
            costLabel.text = "平均消费 \(model.average_cost) 元"
            //addressLabel
            addressLabel.text = model.address
            //distanceLabel
            if model.distance == "-1" { //和后台约好返回的无法解析地址
                distanceImageView.isHidden = true
                distanceLabel.isHidden = true
            } else {
                distanceImageView.isHidden = false
                distanceLabel.isHidden = false
                distanceLabel.text = "距离：\(model.distanceKM)km"
            }
            //statusLabel
            var statusStr = ""
            switch model.statusType {
            case .toCheck:
                statusStr = "待查单"
            case .querying:
                statusStr = "查询中"
            case .checked:
                statusStr = "已查单"
            case .toTestify:
                statusStr = "待验单"
            case .cancel:
                statusStr = "客户取消"
            case .contact:
                statusStr = "联系中"
            case .accept:
                statusStr = "正在验单"
            case .access:
                statusStr = "通过验证"
            case .empty:
                statusStr = "无此活动"
            case .toOrder2:
                statusStr = "待预约二次验证"
            case .toTestify2:
                statusStr = "二次验证中"
            case .busy:
                statusStr = "正在忙"
            case .uploaded:
                statusStr = "凭证已上传"
            default:
                statusStr = "完成"
            }
            statusLabel.text = statusStr
        }
    }
}
