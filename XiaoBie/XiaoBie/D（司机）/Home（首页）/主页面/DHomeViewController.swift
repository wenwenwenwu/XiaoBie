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
        view.addSubview(infoView)
        view.addSubview(selectView)
        view.addSubview(pageView)
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
        setupUI()
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
    
    //MARK: - Request
    func infoRequest() {
        let staffId = AccountTool.userInfo().id        
        WebTool.post(uri: "get_profile", para: ["staff_id" : staffId], success: { (dict) in
            let model = DHomeInfoResponseModel.parse(dict: dict)
            if model.code == "0" {
                let infoModel = model.data
                self.infoView.model = infoModel
                self.selectView.titleArray = ["待查单(\(infoModel.need_query_count))", "已查单(\(infoModel.need_appoint_count))", "待验单(\(infoModel.need_verify_count))", "添加营销案(\(infoModel.market_case_count))", "已完成(\(infoModel.complete_count))"]
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
    
    //MARK: - Setup
    func setupUI() {
        view.backgroundColor = gray_F5F5F5
        //leftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .highlighted)
        //rightBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .highlighted)        
    }
    
    //MARK: - Properties
    lazy var leftButtonItem = UIBarButtonItem.init(title: "签到", style: .plain, target: self, action: #selector(clockinButtonEvent))
    
    lazy var rightButtonItem = UIBarButtonItem.init(title: "人工建单", style: .plain, target: self, action: #selector(addButtonEvent))
    
    lazy var titleView = UIImageView.init(image: #imageLiteral(resourceName: "pic_logo"))
    
    lazy var infoView = DHomeInfoView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 117))

    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: infoView.bottom, width: screenWidth, height: 40), titleArray:  ["待查单", "已查单", "待验单", "添加营销案", "已完成"], sliderWidth: 46) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    //pageView
    lazy var toCheckVC = DHomeListViewController.controllerWith(listType: .toCheck)
    lazy var checkedVC = DHomeListViewController.controllerWith(listType: .checked)
    lazy var toTestifyVC = DHomeListViewController.controllerWith(listType: .toTestify)
    lazy var addVC = DHomeListViewController.controllerWith(listType: .add)
    lazy var completeVC = DHomeListViewController.controllerWith(listType: .complete)
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-navigationBarHeight-selectView.bottom-tabbarHeight), VCArray: [toCheckVC, checkedVC, toTestifyVC, addVC, completeVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var clockinHandler = DClockinViewManager.managerWith(ownerController: self)    
}
