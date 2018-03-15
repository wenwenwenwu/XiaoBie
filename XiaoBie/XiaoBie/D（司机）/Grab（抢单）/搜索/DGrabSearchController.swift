//
//  DGrabSearchController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/14.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DGrabSearchController: UISearchController {

    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
        
        //毛玻璃
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
//        _visualEffectView.frame = CGRectMake(0, kNavigationBarConstant, ZDScreenWidth, ZDScreenHeight);
//        [self.view addSubview:_visualEffectView];
        
        let effect = UIBlurEffect.init(style: .light)
        let visualView = UIVisualEffectView.init(effect: effect)
        visualView.frame = screenBounds
        view.addSubview(visualView)
        
        
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
