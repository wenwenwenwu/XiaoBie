//
//  HomeSelectView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/7.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit


class ClockinViewHandler {

     var clockinView = ClockinView()

     var isShow = false {
        didSet{
            if isShow {
                clockinView.show()
            } else {
                clockinView.dismiss()
            }
        }
    }

    class func handlerWith(ownerController: UIViewController, clockinButtonClosure:@escaping ()->Void, clockoutButtonClosure: @escaping ()->Void) -> ClockinViewHandler {
        let handler = ClockinViewHandler()
        handler.clockinView = ClockinView.viewWith(ownerController: ownerController, clockinButtonClosure: clockoutButtonClosure, clockoutButtonClosure: clockoutButtonClosure)
        return handler
    }
}


class ClockinView: UIView {
    
    let animationDuration = 0.3

    var clockinButtonClosure: ()->Void = {}
    var clockoutButtonClosure: ()->Void = {}
    var ownerController: UIViewController?
    
    //MARK: - Factory Method
    class func viewWith(ownerController: UIViewController, clockinButtonClosure: @escaping ()->Void, clockoutButtonClosure: @escaping ()->Void) -> ClockinView {
        let view = ClockinView()
        view.ownerController = ownerController
        view.clockinButtonClosure = clockinButtonClosure
        view.clockoutButtonClosure = clockoutButtonClosure
        return view
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: screenBounds)
        addSubview(backView)
        addSubview(frontView)
        frontView.addSubview(clockinButton)
        frontView.addSubview(clockoutButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK: - Event Response
    @objc func clockinButtonAction() {
        clockinButtonClosure()
    }
    
    @objc func clockoutButtonAction() {
        clockoutButtonClosure()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    //MARK: - Private Method
    func show() {
        backView.alpha = 1
        //动画
        UIView.animate(withDuration: animationDuration) {
            self.frontView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: self.frontView.height)
        }
        //加载
        ownerController?.view.addSubview(self)
    }
    
    func dismiss() {
        UIView.animate(withDuration: animationDuration, animations: {
        self.backView.alpha = 0
            self.frontView.frame = CGRect.init(x: 0, y: -self.frontView.height, width: screenWidth, height: self.frontView.height)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - Request
    
    
    //MARK: - Lazyload
    lazy var backView: UIView = {
        let view = UIView.init(frame: screenBounds)
        view.backgroundColor = black_20
        return view
    }()
    
    lazy var frontView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: -130, width: screenWidth, height: 130))
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var clockinButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 13, y: 20, width: screenWidth-13*2, height: 36)
        button.titleLabel?.font = font14
        button.setTitle("上班打卡", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.setBackgroundImage(gray_CCCCCC.colorImage(), for: .disabled)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(clockinButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var clockoutButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 13, y: 75, width: screenWidth-13*2, height: 36)
        button.titleLabel?.font = font14
        button.setTitle("下班打卡", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.setBackgroundImage(gray_CCCCCC.colorImage(), for: .disabled)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(clockoutButtonAction), for: .touchUpInside)
        return button
    }()
}

