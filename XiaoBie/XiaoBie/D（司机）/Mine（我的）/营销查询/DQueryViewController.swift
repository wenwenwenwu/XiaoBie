//
//  DQueryViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/29.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DQueryViewController: UIViewController,UIWebViewDelegate {
    
    lazy var blankView: BlankView = {
        let blankView = BlankView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-navigationBarHeight))
        return blankView
    }()
    
    lazy var request: URLRequest = {
        let url = URL.init(string: "http://120.55.55.175/in")
        let request = URLRequest.init(url: url!)
        return request
    }()
    
    lazy var webView: UIWebView = {
        let webView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-navigationBarHeight))
        webView.loadRequest(request)
        webView.delegate = self
        return webView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blankView)
        view.addSubview(webView)
        setupNavigationBar()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "营销查询"
    }
    
    func setupBlankView(isBlank: Bool, blankViewType: ViewType?) {
        webView.isHidden = isBlank
        blankView.viewType = blankViewType
        blankView.buttonClosure = { [weak self] in
            if self?.blankView.viewType == .noWeb {
                self?.webView.loadRequest((self?.request)!)
            }
        }
    }
    
    //MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        HudTool.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        setupBlankView(isBlank: false, blankViewType: nil)
        HudTool.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        HudTool.dismiss()
        setupBlankView(isBlank: true, blankViewType: .noWeb)
        webView.isHidden = true
    }
}
