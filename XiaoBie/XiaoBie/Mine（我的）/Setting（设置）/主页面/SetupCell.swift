//
//  SetupCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/8.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

//MARK: - SetupCell
enum SetupCellType {
    case clear
    case rank
    case suggest
    case privacy
    case about
}

class SetupCell: UITableViewCell {
    
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
    class func cellWith(tableView : UITableView) -> SetupCell{
        let reuseIdentifier = "setupCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = SetupCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! SetupCell
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
    
    var type: SetupCellType = .clear {
        didSet {
            switch type {
            case .clear:
                titleLabel.text = "清除缓存"
                infoLabel.text = "\(CacheTool.fileSizeOfCache())M"
            case .rank:
                titleLabel.text = "给龙网评分"
                infoLabel.isHidden = true
            case .privacy:
                titleLabel.text = "隐私协议"
                infoLabel.isHidden = true
            case .suggest:
                titleLabel.text = "建议与反馈"
                infoLabel.isHidden = true
                lineView.isHidden = true
            default:
                titleLabel.text = "关于我们"
                infoLabel.isHidden = true
                lineView.isHidden = true
            }
        }
    }
    
}

//MARK: - LogoutCell
class LogoutCell: UITableViewCell {
    
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
    class func cellWith(tableView : UITableView) -> LogoutCell{
        let reuseIdentifier = "logoutCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = LogoutCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! LogoutCell
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

