//
//  DHomeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DHomeViewController: UIViewController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
        view.addSubview(infoView)
        view.addSubview(selectView)
        view.addSubview(pageView)

        setupNavigationBar()
        infoRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clockinHandler.handle(forceDismiss: true)
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    //MARK: - Request
    func infoRequest() {
        let staffId = AccountTool.userInfo().id        
        WebTool.post(uri: "get_profile", para: ["staff_id" : staffId], success: { (dict) in
            let model = DHomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.infoView.model = model.data
            }else{

            }
        }) { (error) in

        }
    }
    
    //MARK: - Event Response
    @objc func clockinButtonAction() {
        clockinHandler.handle(forceDismiss: false)
    }
   
    @objc func addButtonAction() {
        print("加单")
    }
    
    //MARK: - Private Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
    }
    
    //MARK: - Properties
    lazy var leftButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_dk").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(clockinButtonAction))
    
    lazy var rightButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_jd").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addButtonAction))
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    lazy var infoView = DHomeInfoView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 117))

    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: 40), titleArray:  ["待查单", "待预约", "待验单", "已完成", "二次验证"], sliderWidth: 46) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var toCheckVC = DHomeListViewController.controllerWith(listType: .toCheck)
    lazy var toOrderVC = DHomeListViewController.controllerWith(listType: .toOrder)
    lazy var toTestifyVC = DHomeListViewController.controllerWith(listType: .toTestify)
    lazy var toTestify2VC = DHomeListViewController.controllerWith(listType: .toTestify2)
    lazy var completeVC = DHomeListViewController.controllerWith(listType: .complete)
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-navigationBarHeight-selectView.bottom-tabbarHeight), VCArray: [toCheckVC, toOrderVC, toTestifyVC, toTestify2VC, completeVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var clockinHandler = DClockinViewHandler.handlerWith(ownerController: self)    
}
