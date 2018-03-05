//
//  DDriverListView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DDriverCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(roundLabel)
        contentView.addSubview(driverLabel)
        contentView.addSubview(selectButton)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DDriverCell{
        let reuseIdentifier = "driverCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DDriverCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DDriverCell
    }
    
    //MARK: - Setup
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectButton.isSelected = selected
        if selected {
            selectedClosure()
        }
    }
    
    func setupFrame() {
        roundLabel.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(41)
            
        }
        
        driverLabel.snp.makeConstraints { (make) in
            make.left.equalTo(roundLabel.snp.right).offset(9)
            make.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font14
        label.textColor = white_FFFFFF
        label.backgroundColor = blue_3296FA
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()
    
    lazy var driverLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(#imageLiteral(resourceName: "icon_g_selected"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "icon_g_default"), for: .normal)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F5F5F5
        return view
    }()
    
    var model = DDriverItemModel() {
        didSet {
            driverLabel.text = model.name
            //roundLabel
            let name = model.name
            let rangeFirst = name.startIndex ... name.startIndex
            roundLabel.text = String(name[rangeFirst])
        }
    }
    
    var selectedClosure: ()->Void = {}

}

