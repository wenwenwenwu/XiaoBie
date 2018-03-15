//
//  CHomeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CHomeViewController: UIViewController {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
        view.addSubview(selectView)
        view.addSubview(pageView)
        setupNavigationBar()
        infoRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = white_FFFFFF.colorImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = gray_F0F0F0.colorImage()
        clockinHandler.viewShowupEvent(forceDismiss: true)
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.titleView = titleView
        
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
    }
    
    //MARK: - Request
    func infoRequest() {
        let staffId = AccountTool.userInfo().id
        WebTool.post(uri: "get_profile_for_dealer", para: ["staff_id" : staffId], success: { (dict) in
            let model = CHomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                //更新信息
                let titleArray = ["待查单(\(model.data.need_query_count))", "待验单(\(model.data.need_verify_count))", "添加营销案(\(model.data.market_count))", "已完成(\(model.data.completed_verify_count))"]
                self.selectView.titleArray = titleArray
            }else{
                
            }
        }) { (error) in
            
        }
    }
    
    //MARK: - Event Response
    @objc func clockinButtonAction() {
        clockinHandler.viewShowupEvent(forceDismiss: false)
    }
    
    //MARK: - Private Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
    }
    
    //MARK: - Properties
    lazy var leftButtonItem = UIBarButtonItem.init(title: "签到", style: .plain, target: self, action: #selector(clockinButtonAction))
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40), titleArray:  ["待查单", "待验单", "已验单", "二次验证"], sliderWidth: 46) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    //pageView
    lazy var toCheckVC = CHomeListViewController.controllerWith(listType: .toCheck)
    lazy var toTestifyVC = CHomeListViewController.controllerWith(listType: .toTestify)
    lazy var addVC = CHomeListViewController.controllerWith(listType: .toAdd)
    lazy var completeVC = CHomeListViewController.controllerWith(listType: .complete)
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-navigationBarHeight-selectView.bottom-tabbarHeight), VCArray: [toCheckVC, toTestifyVC, addVC, completeVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var clockinHandler = DClockinViewManager.managerWith(ownerController: self)
}

