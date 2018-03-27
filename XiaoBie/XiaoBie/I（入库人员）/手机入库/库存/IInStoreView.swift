//
//  MInStoreView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/19.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class IInStoreParaView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        addSubview(lineView)
        addGestureRecognizer(tapGesture)
        backgroundColor = white_FFFFFF
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(type: IStoreParaType, paraLabelTapClosure: @escaping ()->Void) -> IInStoreParaView {
        let view = IInStoreParaView()
        view.type = type
        view.paraLabelTapClosure = paraLabelTapClosure
        return view
    }
    
    //MARK: - Action
    @objc func tapAction() {
        paraLabelTapClosure()
    }
    
    //MARK: - Setup
    func setupFrame() {
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var paraLabel: UILabel = {
        let label = UILabel()
        label.textColor = gray_999999
        label.font = font14
        return label
    }()
    
    lazy var arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_xjt_default"))
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.addArrangedSubview(paraLabel)
        stackView.addArrangedSubview(arrowImageView)
        return stackView
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_E5E5E5
        return view
    }()
    
    lazy var tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
    
    var type = IStoreParaType.source {
        didSet {
            switch type {
            case .source:
                paraLabel.text = "来源"
            case .phoneModel:
                paraLabel.text = "型号"
            case .phonePara:
                paraLabel.text = "筛选"
            }
        }
    }
    
    var paraLabelTapClosure: ()->Void = {}
    
    var paraName = "" {
        didSet{
            paraLabel.textColor =  blue_3296FA
            arrowImageView.image = #imageLiteral(resourceName: "icon_xjt_selected")
            paraLabel.text = paraName
        }
    }
}
