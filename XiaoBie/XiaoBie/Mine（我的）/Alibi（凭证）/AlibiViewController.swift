//
//  AlibiViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class AlibiViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(photoButtonView1)
        
        photoButtonView2.isHidden = true
        view.addSubview(photoButtonView2)
        
        photoButtonView3.isHidden = true
        view.addSubview(photoButtonView3)
        
        view.addSubview(uploadButton)
        setupNavigationBar()
        setupFrame()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "上传凭证"
    }
    
    func setupFrame() {
        photoButtonView1.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButtonView2.snp.makeConstraints { (make) in
            make.left.equalTo(photoButtonView1.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButtonView3.snp.makeConstraints { (make) in
            make.left.equalTo(photoButtonView2.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        uploadButton.snp.makeConstraints { (make) in
            make.top.equalTo(105)
            make.right.equalTo(-13)
            make.width.equalTo(76)
            make.height.equalTo(31)
        }
    }
    
    //MARK: - Event Response
    @objc func uploadButtonAction() {
        guard !photoButtonView1.url.isEmpty && !photoButtonView2.url.isEmpty && !photoButtonView3.url.isEmpty else {
            HudTool.showInfo(string: "必须上传3张图片")
            return
        }
        print(photoButtonView1.url, photoButtonView2.url, photoButtonView3.url)
    }


    //MARK: - Properties
    lazy var photoButtonView1 = PhotoButtonView.viewWith(ownVC: self) { [weak self] in
        self?.photoButtonView2.isHidden = false
    }

    lazy var photoButtonView2 = PhotoButtonView.viewWith(ownVC: self) { [weak self] in
        self?.photoButtonView3.isHidden = false
    }

    lazy var photoButtonView3 = PhotoButtonView.viewWith(ownVC: self) {

    }
    
    lazy var uploadButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.titleLabel?.font = font12
        button.setTitle("确认上传", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        return button
    }()



}
