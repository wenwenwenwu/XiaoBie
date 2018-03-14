//
//  MHomeListView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/13.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CHomeListCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> CHomeListCell{
        let reuseIdentifier = "cHomeListCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = CHomeListCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! CHomeListCell
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
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(11, 0, 0, 0))
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
            make.top.equalTo(lineView.snp.bottom).offset(9)
            make.width.equalTo(61)
            make.height.equalTo(61)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.height.equalTo(15)
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
    
    var model = DGrabItemModel() {
        didSet {
            //timeLabel
            timeLabel.text = DateTool.strDateToStr月日时分(strDate: model.update_time)
            //iconImageView
            iconImageView.image = (model.project_type == "0") ? #imageLiteral(resourceName: "icon_phone") : #imageLiteral(resourceName: "icon_ll")
            //nameLabel
            nameLabel.text = model.user_name
            //addressLabel
//            addressLabel.text = model.address
            addressLabel.text = "杭州市西湖区杭大路38号1单元402室杭州市西湖区杭大路38号1单元402室"
            //statusLabel
            var statusStr = ""
            switch model.statusType {
            case .toCheck:
                statusStr = "待查单"
            case .querying:
                statusStr = "查询中"
            case .checked, .checked2:
                statusStr = "已查单"
            case .toTestify:
                statusStr = "待验单"
            case .cancel:
                statusStr = "客户取消"
            case .contact:
                statusStr = "待验单"
            case .accept:
                statusStr = "待验单"
            case .access, .access2:
                statusStr = "通过验证"
            case .empty:
                statusStr = "无此活动"
            case .uploaded, .uploaded2:
                statusStr = "凭证已上传"
            case .complete, .complete2:
                statusStr = "完成"
            case .payComplete:
                statusStr = "付款完成"
            default:
                statusStr = "稍后联系"
            }
            statusLabel.text = statusStr
        }
    }
}

