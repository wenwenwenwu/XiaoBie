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
        whiteView.addSubview(addressLabel)
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
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(16, 13, 0, 13))
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.right.equalTo(grabButton.snp.left).offset(-25)
            make.top.equalTo(14)
        }

        grabButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
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
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font14
        label.textColor = gray_666666
        return label
    }()
    
    lazy var grabButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font12
        button.setTitle("立即抢单", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3899F7.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(grabButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel() {
        didSet {
            addressLabel.text = model.address
        }
    }
    
    var grabButtonClosure: ()->Void = {}
}
