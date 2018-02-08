//
//  MineCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum MineCellType {
    case phone
    case query
    case upload
    case money
    case setup
}

class MineCell: UITableViewCell {
    
    var type: MineCellType = .phone {
        didSet {
            switch type {
            case .phone:
                setupData(icon: #imageLiteral(resourceName: "icon_my_phone"), title: "领手机")
            case .query:
                setupData(icon: #imageLiteral(resourceName: "icon_my_yx"), title: "营销查询")
            case .upload:
                setupData(icon: #imageLiteral(resourceName: "icon_my_pj"), title: "上传凭证")
            case .money:
                setupData(icon: #imageLiteral(resourceName: "icon_my_je"), title: "我的税前酬金")
            default:
                setupData(icon: #imageLiteral(resourceName: "icon_my_sz"), title: "设置")
            }
        }
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> MineCell{
        let reuseIdentifier = "mineCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = MineCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MineCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectedBackgroundView = selectedCellView
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(13)
            make.centerY.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(51)
            make.right.equalTo(-13)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    func setupData(icon: UIImage, title: String) {
        iconView.image = icon
        titleLabel.text = title
    }
    
    //MARK: - Lazyload
    lazy var iconView = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var arrowView = UIImageView.init(image: #imageLiteral(resourceName: "icon_into"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
}
