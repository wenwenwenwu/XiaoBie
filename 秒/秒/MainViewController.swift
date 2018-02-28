//
//  MainViewController.swift
//  秒
//
//  Created by wuwenwen on 2018/2/28.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yellowVC = YellowViewController()
        let redVC = RedViewController()
        
        addChildViewController(yellowVC)
        addChildViewController(redVC)
        // Do any additional setup after loading the view.
        
        
        view.addSubview(yellowVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
