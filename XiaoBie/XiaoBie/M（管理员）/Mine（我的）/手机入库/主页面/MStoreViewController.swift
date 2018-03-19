//
//  MStoreViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MStoreViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加
        view.addSubview(selectView)
        view.addSubview(pageView)
        navigationItem.rightBarButtonItem = scanButtonItem
        //设置
        navigationItem.title = "入库"
        view.backgroundColor = white_FFFFFF
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = white_FFFFFF.colorImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = gray_F0F0F0.colorImage()
    }
    
    //MARK: - Action
    @objc func calendarButtonAction() {
        //弹出
        let calendarVC = CalendarViewController()
        calendarVC.startDate = startDate
        calendarVC.endDate = endDate
        calendarVC.doneClosure = { startDate, endDate in
            self.calendarVCpickedDateAction(startDate: startDate, endDate: endDate)
        }
        let calendarNC = NavigationController.init(rootViewController: calendarVC)
        self.present(calendarNC, animated: true, completion: nil)
    }
    
    @objc func scanButtonAction() {
        //推出
        let scanVC = DScanViewController()
        scanVC.scanedClosure = { serialNumber in
//            self.claimPhoneRequest(serialNumber: serialNumber)
        }
        navigationController?.pushViewController(scanVC, animated: true)
    }
    
    func calendarVCpickedDateAction(startDate: String, endDate: String) {
        historyVC.startDate = startDate
        historyVC.endDate = endDate
        historyVC.dateView.setupDate(startDate: startDate, endDate: endDate)
        historyVC.loadRequest()
        
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func selectViewChangeCurrentIndexAction(currentIndex: Int) {
        pageView.currentIndex = currentIndex
        switchBarButtonItem(currentIndex: currentIndex)
    }
    
    func pageViewChangeCurrentIndexAction(currentIndex: Int) {
        selectView.currentIndex = currentIndex
        switchBarButtonItem(currentIndex: currentIndex)
    }
    
    //MARK: - Request
    func claimPhoneRequest(serialNumber: String) {
        let staffId = AccountTool.userInfo().id
        
        WebTool.post(uri: "claim_phone_delivery", para: ["staff_id" : staffId, "serial_no" : serialNumber], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
//                self.storeVC.loadRequest()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Action Method
    func switchBarButtonItem(currentIndex: Int) {
        switch currentIndex {
        case 0:
            navigationItem.rightBarButtonItem = scanButtonItem
        default:
            navigationItem.rightBarButtonItem = calendarButtonItem
        }
    }
    
    //MARK: - Properties
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40), titleArray:  ["库存", "历史记录"], sliderWidth: 28) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndexAction(currentIndex: currentIndex)
    }
    
    //pageView
    
//    lazy var storeVC = DStoreViewController()
    lazy var storeVC = MInStoreViewController()

    lazy var historyVC: MHistoryViewController = {
        let VC = MHistoryViewController()
        VC.startDate = startDate
        VC.endDate = endDate
        return VC
    }()
    
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-selectView.bottom-navigationBarHeight), VCArray: [storeVC, historyVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndexAction(currentIndex: currentIndex)
    }
    
    lazy var calendarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_rl").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(calendarButtonAction))
    
    lazy var scanButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_lsj_sys").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanButtonAction))
    
    //记录calendarVC的日期信息,赋值给historyVC的初始日期信息
    var startDate = ""
    var endDate = ""
}
