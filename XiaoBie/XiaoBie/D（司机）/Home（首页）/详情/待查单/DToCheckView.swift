//
//  DToCheckView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/1.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DToCheckInfoCell: UITableViewCell, UITextViewDelegate {
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
        contentView.addSubview(costKeyLabel)
        contentView.addSubview(costValueLabel)
        contentView.addSubview(timeKeyLabel)
        contentView.addSubview(timeValueLabel)
        contentView.addSubview(phoneKeyLabel)
        contentView.addSubview(phoneValueLabel)
        contentView.addSubview(setKeyLabel)
        contentView.addSubview(setValueLabel)
        contentView.addSubview(addressKeyLabel)
        addressTextView.isEditable = false
        contentView.addSubview(addressTextView)
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
    
    //MARK: - Event Response
    @objc func editButtonAction() {
        if addressTextView.isEditable == false {
            addressTextView.isEditable = true
            addressTextView.isScrollEnabled = true
            addressTextView.becomeFirstResponder()
        }
    }
    
    //MARK: - Request
    func updateAddressRequest() {
        WebTool.post(uri:"update_order_info", para:["address": addressTextView.text!, "gtcdw": model.gtcdw, "order_id": model.id, "latitude": location.latitude,"longitude": location.longitude], success: { (dict) in
            let model = DToCheckUpdateAdressResponseModel.parse(dict: dict)
            self.addressTextView.isEditable = false
            self.addressTextView.isScrollEnabled = false
            if model.code == "0" {
                self.finishEditClosure(model.data)
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            self.addressTextView.isEditable = false
            self.addressTextView.isScrollEnabled = false
            HudTool.showInfo(string: error)
        }
    }
    
    
    //MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        locationTool.startUpdatingLocation()
    }
    
    //MARK: - Setup
    func setupFrame() {
        //key
        costKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(costValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        timeKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        phoneKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        setKeyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(setValueLabel)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        
        addressKeyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setKeyLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.height.equalTo(14)
        }
        //value
        costValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(costKeyLabel.snp.right).offset(16)
            make.height.equalTo(15)
        }
        
        timeValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(costValueLabel.snp.bottom).offset(12)
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
        //addressTextView
        addressTextView.snp.makeConstraints { (make) in
            make.top.equalTo(setValueLabel.snp.bottom).offset(2)
            make.left.equalTo(83)
            make.right.equalTo(-67)
            make.bottom.equalTo(-22)
        }
        //distance
        distanceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(90)
            make.bottom.equalTo(-14)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceImageView.snp.right).offset(3)
            make.centerY.equalTo(distanceImageView)
        }
        //editButton
        editButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.top.equalTo(addressKeyLabel)
        }
    }
    
    //MARK: - Properties
    lazy var costKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "平均话费"
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var costValueLabel: UILabel = {
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
    
    lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.font = font16
        textView.textColor = black_333333
        return textView
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
    
    var location: (latitude: String, longitude: String) = ("", "")
    lazy var locationTool = LocationTool.toolWith { (latitude, longitude) in
        self.location = (latitude, longitude)
        self.updateAddressRequest()
    }
    
    var model = DGrabItemModel() {
        didSet {
            costValueLabel.text = "\(model.average_cost)元"
            timeValueLabel.text = model.update_time
            phoneValueLabel.text = PhoneNumberTool.secret(phoneNumber: model.phone1)
            setValueLabel.text = model.gtcdw
            addressTextView.text = model.address
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
    
    var finishEditClosure: (DGrabItemModel)->Void = { _ in }
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
    
    //MARK: - Event Response
    @objc func scanButtonAction() {
        //每次点击都要创建新的
        let scanVC = DScanViewController()
        scanVC.scanedClosure = { [weak self] serialNumber in
            self?.scanVCScanedAction(serialNumber: serialNumber)
        }
        ownerController!.navigationController!.pushViewController(scanVC, animated: true)
    }
    
    func scanVCScanedAction(serialNumber: String) {
        valueLabel.textColor = black_333333
        valueLabel.text = serialNumber
        scanedClosure(serialNumber)
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
        label.text = "请对准串号扫描"
        label.font = font16
        label.textColor = gray_999999
        return label
    }()
    
    lazy var scanButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(#imageLiteral(resourceName: "icon_sys"), for: .normal)
        button.addTarget(self, action: #selector(scanButtonAction), for: .touchUpInside)
        return button
    }()
    
    weak var ownerController: UIViewController?
    
    var model = DGrabItemModel()
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
