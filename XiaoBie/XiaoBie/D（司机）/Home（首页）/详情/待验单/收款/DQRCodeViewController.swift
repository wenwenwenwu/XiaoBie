//
//  DQRCodeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/13.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import Kingfisher

class DQRCodeViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(whiteSquareView)
        whiteSquareView.addSubview(infoLabel)
        whiteSquareView.addSubview(QRCodeImageView)
        view.addSubview(whiteBackView)
        whiteBackView.addSubview(cancelButton)
        whiteBackView.addSubview(lineView)
        whiteBackView.addSubview(confirmButton)
        view.backgroundColor = blue_3296FA
        setupFrame()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    //MARK: - Factory Method
    class func controllerWith(payMethod: PayMethod, payMoney: String, model:DGrabItemModel) -> DQRCodeViewController {
        let controller = DQRCodeViewController()
        controller.payMethod = payMethod
        controller.payMoney = payMoney
        controller.model = model
        return controller        
    }
    
    //MARK: - Request
    func cancelRequest() {
        WebTool.post(isShowHud: false, uri:"cancel_order", para:["staff_id": AccountTool.userInfo().id, "order_id":model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                //跳转回待验单主页面
                self.navigationController?.popToRootViewController(animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Event Response
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonAction() {
        Alert.showAlertWith(style: .alert, controller: self, title: "确定要取消订单吗", message: nil, functionButtons: ["确定"]) { _ in
            self.cancelRequest()
        }
    }
    
    @objc func confirmButtonAction() {
        confirmRequest()
    }
    
    //MARK: - Request
    func confirmRequest() {
        WebTool.post(uri:"payment_submit", para:["staff_id": AccountTool.userInfo().id, "plat_form_type": String(payMethod.rawValue), "order_id": model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Setup
    func setupFrame() {
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(statusBarHeight+10)
            make.width.equalTo(14)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        whiteSquareView.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight+64)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(screenWidth-18*2)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(37)
            make.centerX.equalToSuperview()
        }
        
        QRCodeImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(186)
        }

        whiteBackView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(lineView.snp.left)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(17)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(lineView.snp.right)
        }
    }
    
    //MARK: - Properties
    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "icon_wreturn"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "收款"
        label.font = font18Medium
        label.textColor = white_FFFFFF
        return label
    }()
    
    lazy var whiteSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "扫一扫，向我付钱"
        label.font = font15
        label.textColor = black_333333
        return label
    }()

    lazy var QRCodeImageView: UIImageView = {
        let imageView = UIImageView()
        var QRCodeTypePara = String(payMethod.rawValue - 1)//0表示支付宝二维码, 1表示微信二维码
        imageView.kf.setImage(with: URL.init(string: QRCodeImageURL+QRCodeTypePara), placeholder: gray_F5F5F5.colorImage(), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        return imageView
    }()
    
    lazy var whiteBackView: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("客户取消", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("确认收款", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    var payMoney = ""
    var model: DGrabItemModel = DGrabItemModel()
    var payMethod: PayMethod = .zhifubao
}
