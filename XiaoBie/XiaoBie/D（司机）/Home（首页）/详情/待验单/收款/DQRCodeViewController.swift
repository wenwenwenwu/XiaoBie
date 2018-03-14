//
//  DQRCodeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/13.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DQRCodeViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.addSubview(whiteView)
        whiteView.addSubview(cancelButton)
        whiteView.addSubview(lineView)
        whiteView.addSubview(confirmButton)
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
    
    //MARK: - Event Response
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonAction() {
        print("取消")
    }
    
    @objc func confirmButtonAction() {
        print("确认收款")
    }
    
    //MARK: - Setup
    func setupFrame() {
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(30)
        }
        
        whiteView.snp.makeConstraints { (make) in
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
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("客户取消", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.setBackgroundImage(white_FFFFFF.colorImage(), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("确认收款", for: .normal)
        button.setTitleColor(blue_3296FA, for: .normal)
        button.setBackgroundImage(white_FFFFFF.colorImage(), for: .normal)
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_D9D9D9
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 15, y: 35, width: 14, height: 28)
        button.setBackgroundImage(#imageLiteral(resourceName: "icon_wreturn"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
}
