//
//  MyPhoneViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MyPhoneViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(selectView)
        view.addSubview(pageView)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = white_FFFFFF.colorImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = gray_F0F0F0.colorImage()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "领手机"
        navigationItem.rightBarButtonItem = scanButtonItem

    }
    
    //MARK: - Private Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
        switchBarButtonItem(currentIndex: currentIndex)
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
        switchBarButtonItem(currentIndex: currentIndex)
    }
    
    func switchBarButtonItem(currentIndex: Int) {
        switch currentIndex {
        case 0:
            navigationItem.rightBarButtonItem = scanButtonItem
        default:
            navigationItem.rightBarButtonItem = calendarButtonItem
        }
    }
    
    
    //MARK: - Event Response
    @objc func calendarButtonAction() {
        //弹出
        let calendarVC = CalendarViewController()
        calendarVC.startDate = startDate
        calendarVC.endDate = endDate

        calendarVC.doneClosure = { startDate, endDate in
            self.historyVC.startDate = startDate
            self.historyVC.endDate = endDate
            self.historyVC.dateView.setupDate(startDate: startDate, endDate: endDate)
            self.historyVC.loadRequest()
            
            self.startDate = startDate
            self.endDate = endDate
        }
        let calendarNC = NavigationController.init(rootViewController: calendarVC)
        self.present(calendarNC, animated: true, completion: nil)
    }
    
    @objc func scanButtonAction() {
        //推出
        let scanVC = ScanViewController()
        scanVC.scanedClosure = { serialNumber in
            self.storeVC.loadRequest()
        }
        navigationController?.pushViewController(scanVC, animated: true)
    }
    
    //MARK: - Properties
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40), titleArray:  ["库存", "历史记录"], sliderWidth: 28) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var storeVC = StoreViewController()
    
    lazy var historyVC: HistoryViewController = {
        let VC = HistoryViewController()
        VC.startDate = startDate
        VC.endDate = endDate
        return VC
    }()
    
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-selectView.bottom-navigationBarHeight), VCArray: [storeVC, historyVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var calendarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_rl").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(calendarButtonAction))
    
    lazy var scanButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_lsj_sys").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanButtonAction))
    
    //记录calendarVC的日期信息,赋值给historyVC的初始日期信息
    var startDate = DateTool.str本月一号()
    var endDate = DateTool.str今天()
}
