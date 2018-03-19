//
//  MStoreParaPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum MStoreParaType {
    case source
    case phoneModel
    case phonePara
}

class MStoreParaPopView: UIView, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(ownerVC: UIViewController, pickedClosure:  @escaping (MStoreParaType,String)->Void) -> MStoreParaPopView {
        let popView = MStoreParaPopView.init(frame: CGRect.init(x: 0, y: 40, width: screenWidth, height: screenHeight-navigationBarHeight-40))
        popView.ownerVC = ownerVC
        popView.pickedClosure = pickedClosure
        return popView
    }
    
    //MARK: - Action
    func showActionWith(type: MStoreParaType) {
        if isShow {
            self.dismiss()
        } else {
            self.type = type
            sourceRequest()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    //MARK: - Request
    func sourceRequest() {
        WebTool.post(isShowHud: false, uri: uri, para: para, success: { (dict) in
            let model = MHistoryPickParaResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.dataArray = model.data
                self.show()
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Action Method
    func show() {
        //collectionView高度
        let rowNumber = dataArray.count/4+1
        let height = 15 * (rowNumber + 1) + 30 * rowNumber
        //动画
        UIView.animate(withDuration: animationTime) {
            self.collectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: CGFloat(height))
            self.backView.alpha = 1
        }
        //记录状态
        isShow = true
        //加载
        ownerVC.view.addSubview(self)
    }
    
    func dismiss() {
        UIView.animate(withDuration: animationTime, animations: {
            self.collectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 0)
            self.backView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
        //记录状态
        isShow = false
    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCell", for: indexPath) as! MHistoryPickCell
        cell.setupData(type: type, model: dataArray[indexPath.row])
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //Cell尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth-15*5)/4
        return CGSize.init(width: width, height: 30)
    }
    //每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }
    //上下行cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //同一行的cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //回调
        let cell = collectionView.cellForItem(at: indexPath) as! MHistoryPickCell
        pickedClosure(type, cell.itemLabel.text!)
        //消失
        dismiss()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        //设置颜色
        let cell = collectionView.cellForItem(at: indexPath) as! MHistoryPickCell
        cell.itemLabel.textColor = blue_3899F7
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //设置颜色
        let cell = collectionView.cellForItem(at: indexPath) as! MHistoryPickCell
        cell.itemLabel.textColor = black_333333
    }
    
    //MARK: - Properties
    lazy var backView: UIView = {
        let backView = UIView()
        backView.frame = self.frame
        backView.backgroundColor = black_20
        return backView
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = white_FFFFFF
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MHistoryPickCell.self, forCellWithReuseIdentifier: "pickCell")
        return collectionView
    }()
    
    var ownerVC = UIViewController()
    var pickedClosure: (MStoreParaType, String)->Void = {_,_  in }
    
    var uri = ""
    var para: [String : String] = [:]
    
    var type = MStoreParaType.source {
        didSet {
            switch type {
            case .source:
                uri = "list_phone_source"
                para = [:]
            case .phoneModel:
                uri = "list_phone_model"
                para = [:]
            case .phonePara:
                uri = "list_phone_param"
                para = ["model_id":"1", "param_type":"0"]
            }
        }
    }
    
    var isShow = false
    
    var dataArray: [MHistoryPickParaModel] = []
}

class MHistoryPickCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //如果只是背景色的话可以和itemLabel的textColor一样，在UICollectionViewDelegate中设置，但是本项目需要圆角
        backgroundView = grayView
        selectedBackgroundView = blueView
        contentView.addSubview(itemLabel)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        itemLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setupData(type: MStoreParaType, model: MHistoryPickParaModel) {
        switch type {
        case .source:
            itemLabel.text = model.source_name
        case .phoneModel:
            itemLabel.text = model.model_name
        case .phonePara:
            itemLabel.text = model.param_name
        }
    }
    
    //MARK: - Properties
    lazy var itemLabel: UILabel = {
        let label = UILabel.init(frame: frame)
        label.font = font12
        return label
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = blue_EBF5FF
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
}


