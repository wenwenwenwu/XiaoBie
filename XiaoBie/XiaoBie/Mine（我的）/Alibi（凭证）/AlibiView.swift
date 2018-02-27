//
//  AlibiView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoButtonView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(ownVC: UIViewController, uploadCompleteClosure: @escaping ()->Void) -> PhotoButtonView {
        let view = PhotoButtonView()
        view.ownVC = ownVC
        view.uploadCompleteClosure = uploadCompleteClosure
        return view
    }
    
    //MARK: - Setup
    func setupFrame() {
        photoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Event Response
    @objc func tapAction() {
        Alert.showAlertWith(style: .actionSheet, controller: ownVC, title: nil, message: nil, buttons: ["相机拍照","照片图库"]) { (button) in
            if button == "相机拍照" {
                self.photoPickerTool.openCamera()
            }
            if button == "照片图库" {
                self.photoPickerTool.openAlbum()
            }
        }
    }
    
    //MARK: - Properties
    lazy var photoView: UIImageView = {
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "pic_upload"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var photoPickerTool = PhotoPickerTool.photoPickerWith(uploadPara: "upload_daily_evidence", ownerViewController: ownVC) { (url, localURL) in
        self.url = url
        self.photoView.kf.setImage(with: URL.init(string: localURL))
        self.uploadCompleteClosure()
    }
    
    var uploadCompleteClosure: ()->Void = {}
    
    var url = ""
    var ownVC = UIViewController()
}
