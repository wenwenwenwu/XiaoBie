//
//  DToCheckView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/1.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToCheckInfoCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(nameKeyLabel)
        contentView.addSubview(nameValueLabel)
        contentView.addSubview(timeKeyLabel)
        contentView.addSubview(timeValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(setValueLabel)
        contentView.addSubview(addressKeyLabel)
        contentView.addSubview(addressValueLabel)
        contentView.addSubview(distanceImageView)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(editButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToCheckInfoCell{
        let reuseIdentifier = "infoCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToCheckInfoCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToCheckInfoCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        //key
        nameKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        timeKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        phoneKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        setKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        addressKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        //value
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(nameKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        timeValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameValueLabel.snp.bottom).offset(12)
            make.left.equalTo(timeKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        phoneValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(12)
            make.left.equalTo(phoneKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        setValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(12)
            make.left.equalTo(setKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        addressValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setValueLabel.snp.bottom).offset(8)
            make.left.equalTo(83)
            make.right.equalTo(-67)
            make.bottom.equalTo(-32)
        }
        
        //distance
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(85)
            make.bottom.equalTo(-14)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.centerY.equalTo(distanceImageView)
        }
        
        editButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.top.equalTo(addressKeyLabel)
        }
    }
    
    //MARK: - Event Response
    @objc func editButtonAction() {
        editButtonClosure()
    }
    
    //MARK: - Properties
    lazy var nameKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "客户姓名"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var nameValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var timeKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "订单时间"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var timeValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var phoneKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "联系方式"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var phoneValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var setKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "套餐档位"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var setValueLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var addressKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "联系地址"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var addressValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var distanceImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_dw"))
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = font10
        label.textColor = gray_999999
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_bj"), for: .normal)
        button.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        return button
    }()
    
    var model = DGrabItemModel() {
        didSet {
            nameValueLabel.text = model.user_name
            timeValueLabel.text = model.update_time
            phoneValueLabel.text = model.phone1
            setValueLabel.text = model.gtcdw
            addressValueLabel.text = model.address
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
    
    var editButtonClosure: ()->Void = {}
}

class DToCheckScanCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(scanButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToCheckScanCell{
        let reuseIdentifier = "scanCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToCheckScanCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToCheckScanCell
    }
    
    //MARK: - Setup
    func setupFrame() {
        keyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.height.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(keyLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        
        scanButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
    
    //MARK: - Event Response
    @objc func scanButtonAction() {
        ownerController!.navigationController!.pushViewController(scanVC, animated: true)
    }
    
    //MARK: - Properties
    lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.text = "手机串号"
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var scanButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_sys"), for: .normal)
        button.addTarget(self, action: #selector(scanButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var scanVC: DScanViewController = {
        let scanVC = DScanViewController()
        scanVC.scanedClosure = { [weak self] serialNumber in
            self?.valueLabel.text = serialNumber
            self?.scanedClosure(serialNumber)
        }
        return scanVC
    }()
    
    weak var ownerController: UIViewController?
    
    var scanedClosure: (String)->Void = { _ in }
    
    
}

class DToCheckClerkCell: UITableViewCell {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(clerkLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(selectButton)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DToCheckClerkCell{
        let reuseIdentifier = "clerkCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DToCheckClerkCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DToCheckClerkCell
    }
    
    //MARK: - Setup
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        selectButton.isSelected = selected
    }
    
    func setupFrame() {
        clerkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.height.equalTo(15)
            make.bottom.equalTo(-15)

        }
        
//        statusLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(keyLabel.snp.right).offset(15)
//            make.centerY.equalToSuperview()
//        }
        
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var clerkLabel: UILabel = {
        let label = UILabel()
        label.font = font16
        label.textColor = black_333333
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    var model = DToCheckClerkModel() {
        didSet {
            clerkLabel.text = model.name
        }
    }
    
}
