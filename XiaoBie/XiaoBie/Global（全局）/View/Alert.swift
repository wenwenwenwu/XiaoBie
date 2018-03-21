//
//  ActionSheet.swift
//  1
//
//  Created by wuwenwen on 2017/11/21.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

class Alert{
    
    class func showAlertWith(style: UIAlertControllerStyle,controller: UIViewController, title:String?, message: String?, functionButtons: [String], cancelButton: String? = "取消", closure: @escaping (String!)->Void){
        //创建
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style )
        alertController.view.tintColor = blue_3296FA
        //功能按钮
        for item in functionButtons {
            let alertAction = UIAlertAction.init(title: item, style: UIAlertActionStyle.default, handler: { (action) in                
                closure(action.title)
            })
            alertController.addAction(alertAction)
        }
        //取消按钮
        if let cancelTitle = cancelButton {
            let cancelAction = UIAlertAction.init(title: cancelTitle, style: UIAlertActionStyle.cancel) { _ in }
            alertController.addAction(cancelAction)
        }
        
        //呈现
        DispatchQueue.main.async {
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
}
