//
//  ProgressHUDManager.swift
//  LoveFreshBeen

import UIKit
import MBProgressHUD

class HudTool {
    
    static let keyWindow = UIApplication.shared.keyWindow!
    
    class func showInfo(string : String, closure: @escaping ()->Void = {}){
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = string
        hud.detailsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        hud.detailsLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        hud.bezelView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hud.margin = 10
        hud.bezelView.layer.cornerRadius = 10;
        hud.hide(animated: true, afterDelay: 1.5)
        hud.completionBlock = closure
    }
    
    class func show() {
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)//默认菊花
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.color=UIColor.clear
    }
    
    class func dismiss() {
        MBProgressHUD.hide(for: keyWindow, animated: true)
        MBProgressHUD.hide(for: keyWindow, animated: true)//以防万一
        MBProgressHUD.hide(for: keyWindow, animated: true)//以防万一
        
    }
}



