//
//  MLocationCell.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/20.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MLocationCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> MLocationCell{
        let reuseIdentifier = "locationCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = MLocationCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MLocationCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationImageView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(lineView)
        contentView.backgroundColor = white_FFFFFF
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(14)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.height.equalTo(15)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.right.equalTo(-14)
            make.height.equalTo(9)
        }
        
        locationImageView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalTo(avatarImageView.snp.right).offset(11)
            make.width.equalTo(12)
            make.height.equalTo(15)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalTo(locationImageView.snp.right).offset(5)
            make.right.equalTo(-14)
            make.bottom.equalTo(-14)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = font16Medium
        label.textColor = black_333333
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var locationImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_dw"))
    
    lazy var addressLabel: UILabel = {
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
    
    var model = MLocationItemModel() {
        didSet {
            nameLabel.text = model.name
            addressLabel.text = model.address
            dateLabel.text = DateTool.strDateToStrMDHM(strDate: model.update_time)
            //avatarImageView
            let urlStr = "\(model.image_host)\(model.avatar)"
            avatarImageView.kf.setImage(with: URL.init(string: urlStr), placeholder: gray_D9D9D9.colorImage(), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
