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
        view.addSubview(searchButton)
        view.addSubview(selectView)
        view.addSubview(pageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Private Method
    func selectViewChangeCurrentIndex(currentIndex: Int) {
        pageView.currentIndex = currentIndex
    }
    
    func pageViewChangeCurrentIndex(currentIndex: Int) {
        selectView.currentIndex = currentIndex
    }

    
    //MARK: - Event Response
    @objc func searchButtonAction() {
        print("搜索")
    }
    
    //MARK: - Lazyload
    lazy var searchButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 13, y: 26, width: screenWidth-13*2, height: 34)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(gray_F5F5F5.colorImage(), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        button.titleLabel?.font = font16
        button.setTitle("搜索", for: .normal)
        button.setTitleColor(gray_B3B3B3, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var selectView = SelectView.viewWith(frame: CGRect.init(x: 60, y: searchButton.bottom, width: screenWidth-60*2, height: 44), titleArray:  ["全部", "送手机", "送宽带"], sliderWidth: 35) { [weak self] (currentIndex) in
        self?.selectViewChangeCurrentIndex(currentIndex: currentIndex)
    }
    
    //pageView
    lazy var allVC = GrabListViewController.controllerWith(listType: .all)
    lazy var phoneVC = GrabListViewController.controllerWith(listType: .phone)
    lazy var webVC = GrabListViewController.controllerWith(listType: .web)
    lazy var pageView = PageView.viewWith(ownerVC: self, frame: CGRect.init(x: 0, y: selectView.bottom, width: screenWidth, height: screenHeight-selectView.bottom-tabbarHeight), VCArray: [allVC, phoneVC, webVC]) { [weak self] (currentIndex) in
        self?.pageViewChangeCurrentIndex(currentIndex: currentIndex)
    }
}
