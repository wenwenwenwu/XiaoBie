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
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(whiteView)
        whiteView.addSubview(iconImageView)
        whiteView.addSubview(nameLabel)
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
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(13, 13, 0, 13))
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(11)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(61)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.top.equalTo(11)
            make.height.equalTo(15)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.right.equalTo(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
        }
        
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.centerY.equalTo(distanceLabel)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
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
            iconImageView.image = (model.project_type == "0") ? #imageLiteral(resourceName: "icon_phone") : #imageLiteral(resourceName: "icon_ll")
            //nameLabel
            nameLabel.text = model.user_name
            //addressLabel
            addressLabel.text = model.address
            //distanceLabel
            if model.distance == "-1" { //和后台约好返回的无法解析地址
                distanceImageView.isHidden = true
                distanceLabel.isHidden = true
            } else {
                distanceImageView.isHidden = false
                distanceLabel.isHidden = false
                let distanceKM = Float(model.distance)!/1000
                let strDistanceKM = String(format: "%.2f", distanceKM)
                distanceLabel.text = "距离：\(strDistanceKM)km"
            }
            
        }
    }
    
    var grabButtonClosure: ()->Void = {}
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
            make.centerY.equalToSuperview()
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
            make.centerY.equalToSuperview()
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
