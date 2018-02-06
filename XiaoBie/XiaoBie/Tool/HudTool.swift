//
//  ProgressHUDManager.swift
//  LoveFreshBeen

import UIKit
import MBProgressHUD

//单例
let hudManager = HudTool.instanceManager
class HudTool {
    
    let keyWindow = UIApplication.shared.keyWindow!
    
    //创建单例
    static let instanceManager : HudTool = HudTool()    
    private init() { }
    
    func showInfo(string : String, closure: @escaping ()->Void = {}){
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = string
        hud.detailsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        hud.detailsLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        hud.bezelView.color=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hud.margin = 10
        hud.bezelView.layer.cornerRadius = 10;
        hud.hide(animated: true, afterDelay: 1.5)
        hud.completionBlock = closure
        
    }
    
    func showNetErrorInfo(){
        self.showInfo(string: "网络错误")
    }
    
    func show() {
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.color=UIColor.clear
    }
    
    func dismiss() {
        MBProgressHUD.hide(for: keyWindow, animated: true)
        MBProgressHUD.hide(for: keyWindow, animated: true)//以防万一
        MBProgressHUD.hide(for: keyWindow, animated: true)//以防万一

    }
    
    
}



