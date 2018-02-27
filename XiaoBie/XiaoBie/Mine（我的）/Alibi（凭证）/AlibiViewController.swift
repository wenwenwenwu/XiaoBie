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
        view.backgroundColor = gray_F5F5F5
        view.addSubview(uploadView)
        setupNavigationBar()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "上传凭证"
    }

    //MARK: - Properties
    lazy var uploadView: UploadView = {
        let view = UploadView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 150))
        view.ownVC = self
        return view        
    }()

}
