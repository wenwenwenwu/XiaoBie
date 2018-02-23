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
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "领手机"
        navigationItem.rightBarButtonItem = calendarButtonItem
        navigationController?.navigationBar.shadowImage = white_FFFFFF.colorImage()

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
            navigationItem.rightBarButtonItem = calendarButtonItem
        default:
            navigationItem.rightBarButtonItem = scanButtonItem
        }
    }
    
    
    //MARK: - Event Response
    @objc func calendarButtonAction() {
        print("日历")
    }
    
    @objc func scanButtonAction() {
        print("扫描")
    }
    
    //MARK: - Properties
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40), titleArray:  ["库存", "历史记录"], sliderWidth: 28) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var pinkVC: UIViewController = {
        let VC = UIViewController()
        VC.view.backgroundColor = #colorLiteral(red: 1, green: 0.9545792937, blue: 0.9687885642, alpha: 1)
        return VC
    }()
    
    lazy var blueVC: UIViewController = {
        let VC = UIViewController()
        VC.view.backgroundColor = #colorLiteral(red: 0.9275814891, green: 0.9614334702, blue: 1, alpha: 1)
        return VC
    }()
    
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-selectView.bottom), VCArray: [pinkVC, blueVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    lazy var calendarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_rl").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(calendarButtonAction))
    
    lazy var scanButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "icon_lsj_sys").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanButtonAction))
}
