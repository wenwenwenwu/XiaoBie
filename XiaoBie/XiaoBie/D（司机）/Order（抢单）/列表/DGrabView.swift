//
//  DGrabCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/9.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DGrabCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(whiteView)
        whiteView.addSubview(iconImageView)
        whiteView.addSubview(addressLabel)
        whiteView.addSubview(distanceImageView)
        whiteView.addSubview(distanceLabel)
        whiteView.addSubview(grabButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DGrabCell{
        let reuseIdentifier = "grabCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DGrabCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DGrabCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(13, 13, 0, 13))
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(61)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.right.equalTo(-15)
            make.top.equalTo(9)
        }

        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.centerY.equalTo(distanceLabel)
        }

        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.top.equalTo(addressLabel.snp.bottom).offset(18)
            make.height.equalTo(10)
        }
        
        grabButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-16)
            make.width.equalTo(76)
            make.height.equalTo(31)
        }
    }
    
    //MARK: - Event Response
    @objc func grabButtonAction() {
        grabButtonClosure()
    }
    
    //MARK: - Properties
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
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
    
    lazy var distanceImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_dw"))
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = font10
        label.textColor = gray_999999
        return label
    }()
    
    lazy var grabButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font12
        button.setTitle("立即抢单", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(grabButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel() {
        didSet {
            //iconImageView
            iconImageView.image = #imageLiteral(resourceName: "icon_phone")
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
            
        }
    }
    
    var grabButtonClosure: ()->Void = {}
}
