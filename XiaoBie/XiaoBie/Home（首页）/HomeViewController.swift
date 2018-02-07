//
//  HomeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
        
    lazy var leftButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_dk").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(clockinButtonAction))
    
    lazy var rightButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_jd").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addButtonAction))
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    lazy var infoView = HomeInfoView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 117))
    
    lazy var clockinHandler = ClockinViewHandler.handlerWith(ownerController: self, clockinButtonClosure: {
        print("上班打卡")
    }) {
        print("下班打卡")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoView)

        setupNavigationBar()
        infoRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clockinHandler.isShow = false
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    //MARK: - Request
    func infoRequest() {
        WebTool.post(uri: "get_profile", para: ["staff_id" : "1"], success: { (dict) in
            let model = HomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.infoView.model = model.data
            }else{

            }
        }) { (error) in

        }
    }
    
    //MARK: - Event Response
    @objc func clockinButtonAction() {
        clockinHandler.isShow = !clockinHandler.isShow
    }
   
    @objc func addButtonAction() {
        print("加单")
    }
    
    

    
}
