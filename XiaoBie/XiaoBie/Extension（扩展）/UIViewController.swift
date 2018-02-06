//
//  ViewController.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/30.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

extension UIViewController {

    func resignKeyBoardInView(view: UIView) {
        for item in view.subviews {
            if item.subviews.count > 0 {
                resignKeyBoardInView(view: item)
            }
            if item.isKind(of: UITextView.self) || item.isKind(of: UITextField.self) {
                item.resignFirstResponder()
            }
        }
    }
}
