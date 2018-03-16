//
//  DGrabSearchController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/14.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DGrabSearchController: UISearchController {

    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
       
        /*
         //不设置的话iOS上不显示呵呵
         CGRect rect = self.searchBar.frame;
         rect.size.height = 44;
         self.searchBar.frame = rect;
         
         
         
         self.searchBar.tintColor = ZDColorRGB(0x48d2d9);//光标色
         self.searchBar.barTintColor = ZDColorRGB(0xefeff4);//背景色
         self.searchBar.returnKeyType = UIReturnKeySearch;//搜索键
         */
        
   
        
    }
}
