//
//  DChatViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DChatViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(searchButton)
        setupNavigationBar()
    }

    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "聊天"
    }
    
    //MARK: - Event Response
    @objc func searchButtonAction() {
        print("搜索")
    }
    
    //MARK: - Properties
    lazy var searchButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 13, y: 9, width: screenWidth-13*2, height: 34)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(gray_EBEBEB.colorImage(), for: .normal)
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

}
