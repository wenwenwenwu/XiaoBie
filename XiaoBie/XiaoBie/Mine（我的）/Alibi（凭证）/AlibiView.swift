//
//  AlibiView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class UploadView: UIView {

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = white_FFFFFF
        addSubview(photoButton1)
        addSubview(photoButton2)
        addSubview(photoButton3)
        addSubview(uploadButton)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        photoButton1.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButton2.snp.makeConstraints { (make) in
            make.left.equalTo(photoButton1.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        photoButton3.snp.makeConstraints { (make) in
            make.left.equalTo(photoButton2.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(76)
        }
        
        uploadButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.bottom.equalTo(-15)
            make.width.equalTo(76)
            make.height.equalTo(31)
        }
    }
    
    //MARK: - Event Response
    @objc func photoButtonAction(_ sender: UIButton) {
        Alert.showAlertWith(style: .actionSheet, controller: ownVC, title: nil, message: nil, buttons: ["相机拍照","照片图库"]) { (button) in
            if button == "相机拍照" {
                self.photoPickerTool.openCamera()
            }
            if button == "照片图库" {
                self.photoPickerTool.openAlbum()
            }
        }
    }
    
    @objc func uploadButtonAction(_ sender: UIButton) {
        
    }
    
    //MARK: - Properties
    lazy var photoButton1: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(#imageLiteral(resourceName: "pic_upload"), for: .normal)
        button.addTarget(self, action: #selector(photoButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var photoButton2: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(photoButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var photoButton3: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(photoButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.titleLabel?.font = font12
        button.setTitle("确认上传", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(photoButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var photoPickerTool = PhotoPickerTool.photoPickerWith(ownerViewController: ownVC) { (URL, localURL) in
        print(URL, localURL)
    }
    
    var ownVC = UIViewController()    
}
