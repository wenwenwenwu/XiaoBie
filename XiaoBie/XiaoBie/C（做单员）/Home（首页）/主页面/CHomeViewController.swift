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
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = clockinButtonItem
        
        view.addSubview(infoView)
        view.addSubview(selectView)
        view.addSubview(pageView)

        view.backgroundColor = gray_F5F5F5

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @objc func addButtonEvent() {
        let creatVC = DCreatViewController()
        let creatNav = NavigationController.init(rootViewController: creatVC)
        present(creatNav, animated: true, completion: nil)
    }
    
    //收到推送刷新信息时使用
    func reloadData() {
        //selectView刷新
        infoRequest()
        //pageView刷新
        toCheckVC.loadRequest()
        toTestifyVC.loadRequest()
        addVC.loadRequest()
        completeVC.loadRequest()
    }
    
    //MARK: - Request
    func infoRequest() {
        let staffId = AccountTool.userInfo().id
        WebTool.post(uri: "get_profile_for_dealer", para: ["staff_id" : staffId], success: { (dict) in
            let model = CHomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                let infoModel = model.data
                self.infoView.model = infoModel
                self.selectView.titleArray = ["待查单(\(infoModel.need_query_count))", "待验单(\(infoModel.need_verify_count))", "营销案(\(infoModel.need_market_count))", "已完成(\(infoModel.completed_count))"]
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
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    lazy var infoView = CHomeInfoView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 117))
    
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: 40), titleArray:  ["待查单", "待验单", "营销案", "已完成"], sliderWidth: 46) { [weak self] (currentIndex) in
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

