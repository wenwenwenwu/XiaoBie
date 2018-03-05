//
//  SetListView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/2.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DSetCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(infoLabel)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DSetCell{
        let reuseIdentifier = "setCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DSetCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DSetCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedClosure()
        }
    }
    
    //MARK: - Properties
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var model = DSetItemModel() {
        didSet{
            infoLabel.text = model.plan_name
        }
    }
    
    var selectedClosure: ()->Void = {}
}

