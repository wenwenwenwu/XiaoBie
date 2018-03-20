//
//  MHomeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MHomeViewController: UIViewController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = clockinButtonItem
        navigationItem.rightBarButtonItem = scratchButtonItem
        view.addSubview(searchButton)
        view.addSubview(infoView)
        infoView.addSubview(infoCell)
        view.addSubview(selectView)
        view.addSubview(pageView)
        
        view.backgroundColor = white_FFFFFF

        infoRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clockinHandler.viewShowupEvent(forceDismiss: true)
    }
    
    //MARK: - Event Response
    @objc func clockinButtonEvent() {
        clockinHandler.viewShowupEvent(forceDismiss: false)
    }
    
    @objc func scratchButtonAction() {
        print("抓单")
    }
    
    @objc func searchButtonAction() {
        print("搜索")
    }
    
    //MARK: - Request
    func infoRequest() {
        let staffId = AccountTool.userInfo().id
        WebTool.post(uri: "get_profile", para: ["staff_id" : staffId], success: { (dict) in
            let model = DHomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                let infoModel = model.data
//                self.infoView.model = infoModel
                
            }else{
                
            }
        }) { (error) in
            
        }
    }
    
    //MARK: - Action Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
    }
    
    //MARK: - Properties
    lazy var clockinButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "签到", style: .plain, target: self, action: #selector(clockinButtonEvent))
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .highlighted)
        return buttonItem
    }()
    
    lazy var scratchButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "抓单", style: .plain, target: self, action: #selector(scratchButtonAction))
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        buttonItem.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .highlighted)
        return buttonItem
    }()
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    
    
    lazy var searchButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.frame = CGRect.init(x: 13, y: 10, width: screenWidth-13*2, height: 34)
        button.titleLabel?.font = font16
        button.setTitleColor(gray_B3B3B3, for: .normal)
        button.setBackgroundImage(gray_F5F5F5.colorImage(), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        button.setTitle("搜索", for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -(button.width/2-30), 0, (button.width/2-30))
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -(button.width/2-35), 0, (button.width/2-35))
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var infoView = MHomeInfoView.init(frame: CGRect.init(x: 0, y: searchButton.bottom, width: screenWidth, height: 117))
    
    lazy var infoCell = MHomeInfoCell.cellWith(image: #imageLiteral(resourceName: "icon_qianbao"), key1: "已完成", key2: "未完成")
    
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: 40), titleArray:  ["位置", "预警"], sliderWidth: 46) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    //pageView
    lazy var locationVC = MLocationController()
    lazy var alertVC = MAlertViewController()
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-navigationBarHeight-selectView.bottom-tabbarHeight), VCArray: [locationVC, alertVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var clockinHandler = DClockinViewManager.managerWith(ownerController: self)
}

