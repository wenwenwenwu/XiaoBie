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
        whiteView.addSubview(addressLabel)
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
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.right.equalTo(-15)
            make.top.equalTo(lineView.snp.bottom).offset(10)
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
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font14
        label.textColor = gray_666666
        return label
    }()
    
    var model = DGrabItemModel() {
        didSet {
            //timeLabel
            timeLabel.text = DateTool.strDateToStr月日时分(strDate: model.update_time)
            //iconImageView
            iconImageView.image = (model.project_type == "0") ? #imageLiteral(resourceName: "icon_phone") : #imageLiteral(resourceName: "icon_ll")
            //addressLabel
            addressLabel.text = model.address
            //statusLabel
            var statusStr = ""
            switch model.statusType {
            case .toCheck:
                statusStr = "待查单"
            case .querying:
                statusStr = "查询中"
            case .checked:
                statusStr = "已查单"
            case .checked2:
                statusStr = "现场验证"
            case .toTestify:
                statusStr = "待验单"
            case .cancel:
                statusStr = "客户取消"
            case .contact:
                statusStr = "联系中"
            case .accept:
                statusStr = "待验单"
            case .access, .access2:
                statusStr = "通过验证"
            case .empty:
                statusStr = "无此活动"
            case .uploaded, .uploaded2:
                statusStr = "凭证已上传"
            case .complete:
                statusStr = "营销案"
            case .complete2:
                statusStr = "已完成"
            case .payComplete, .paySuccess:
                statusStr = "付款完成"
            case .orderSucess:
                statusStr = "已预约"
            case .orderLater:
                statusStr = "再联系"
            case .orderClose:
                statusStr = "停机"
            case .noCase:
                statusStr = "无法添加营销案"
            default:
                statusStr = "预约失败"
            }
            statusLabel.text = statusStr
        }
    }
}
