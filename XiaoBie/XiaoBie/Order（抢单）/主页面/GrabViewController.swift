//
//  GrabViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class GrabViewController: UIViewController, UIScrollViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(selectView)
        view.addSubview(pageView)
        setupNavigationBar()
    }
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "抢单"
    }
    
    //MARK: - Private Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
    }

    //MARK: - Lazyload
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 60, y: 0, width: screenWidth-60*2, height: 44), titleArray:  ["全部", "送手机", "送宽带"], sliderWidth: 35) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    //pageView
    lazy var allVC = GrabListViewController.controllerWith(listType: .all)
    lazy var phoneVC = GrabListViewController.controllerWith(listType: .phone)
    lazy var webVC = GrabListViewController.controllerWith(listType: .web)
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-selectView.bottom-tabbarHeight-navigationBarHeight), VCArray: [allVC, phoneVC, webVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
}
