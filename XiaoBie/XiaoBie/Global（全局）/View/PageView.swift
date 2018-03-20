//
//  GrabView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/11.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class PageView: UIView, UIScrollViewDelegate {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(ownerVC: UIViewController, frame: CGRect, VCArray: [UIViewController], closure: @escaping (Int)->Void) -> PageView {
        let view = PageView.init(frame: frame)
        
        view.scrollView.contentSize = CGSize.init(width: view.width * CGFloat(VCArray.count), height: view.height)
        
        for item in 0 ..< VCArray.count {
            let VC = VCArray[item]
            ownerVC.addChildViewController(VC)
            view.scrollView.addSubview(VC.view)
            VC.view.frame = CGRect.init(x: screenWidth * CGFloat(item), y: 0, width: screenWidth, height: view.height)
        }
        
        view.closure = closure
        return view
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width
        closure(Int(currentIndex))
    }
    
    //MARK: - Properties
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.backgroundColor = gray_F5F5F5
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    var currentIndex = 0 {
        didSet{
            scrollView.contentOffset = CGPoint.init(x: Int(screenWidth) * currentIndex, y: 0)
        }
    }
    
    var closure: (Int)->Void = {_ in }
}
