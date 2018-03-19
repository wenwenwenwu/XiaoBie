//
//  MInStoreViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MInStoreViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        
        view.backgroundColor = gray_F5F5F5
 
    }
    
    //MARK: - Action
    func sourceViewTapAction() {
        print("来源")
    }
    
    func modelViewTapAction() {
        print("模型")
    }
    
    func paraViewTapAction() {
        print("参数")
    }
    
    //MARK: - Setup
    func setupFrame() {
        
    }

    //MARK: - Properties
    lazy var sourceView = MInStoreParaView.viewWith(type: .source) {
        self.sourceViewTapAction()
    }
    
    lazy var modelView = MInStoreParaView.viewWith(type: .phoneModel) {
        self.modelViewTapAction()
    }
    
    lazy var paraView = MInStoreParaView.viewWith(type: .phonePara) {
        self.paraViewTapAction()
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40))
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sourceView)
        stackView.addArrangedSubview(modelView)
        stackView.addArrangedSubview(paraView)
        return stackView
    }()
    
}
