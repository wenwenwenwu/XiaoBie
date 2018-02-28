//
//  ViewController.swift
//  秒
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class GreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonAction() {
        dismissClosure(color)
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        button.setTitle("退下", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    var dismissClosure: (String)->Void = {_ in }
}

