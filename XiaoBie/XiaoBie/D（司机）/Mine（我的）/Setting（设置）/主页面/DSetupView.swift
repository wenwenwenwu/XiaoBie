//
//  DSetupCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

//MARK: - DSetupCell
enum DSetupCellType {
    case clear
    case version
    case password
}

class DSetupCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectedBackgroundView = selectedCellView
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DSetupCell{
        let reuseIdentifier = "setupCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DSetupCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DSetupCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var arrowView = UIImageView.init(image: #imageLiteral(resourceName: "icon_into"))
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var type: DSetupCellType = .clear {
        didSet {
            switch type {
            case .clear:
                titleLabel.text = "清除缓存"
                infoLabel.text = "\(CacheTool.fileSizeOfCache())M"
            case .password:
                titleLabel.text = "修改密码"
            case .version:
                titleLabel.text = "当前版本"
                infoLabel.text = "1.5"
                lineView.isHidden = true
            }
        }
    }
    
}

//MARK: - DLogoutCell
class DLogoutCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectedBackgroundView = selectedCellView
        contentView.addSubview(titleLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DLogoutCell{
        let reuseIdentifier = "logoutCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DLogoutCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DLogoutCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Lazyload
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "退出登录"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
}

