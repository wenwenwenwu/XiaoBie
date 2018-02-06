//
//  HomeViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        testRequest()
    }
    
    //MARK: - Request
    func testRequest() {
        WebTool.post(uri: "staff_login", para: ["password" : "123455","telephone": "18510337301"], success: { (dict) in
            print(dict)
        }) { (error) in
            print(error)
        }
    }
    
    

    
}
