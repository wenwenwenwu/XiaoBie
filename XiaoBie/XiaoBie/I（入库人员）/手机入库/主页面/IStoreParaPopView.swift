//
//  IStoreParaPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum IStoreParaType {
    case source
    case phoneModel
    case phonePara
}

class IStoreParaPopView: UIView, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(ownerVC: UIViewController, pickedClosure:  @escaping (IStoreParaType,MHistoryPickParaModel)->Void) {
        self.init(frame: CGRect.init(x: 0, y: 40, width: screenWidth, height: screenHeight-navigationBarHeight-40))
        self.ownerVC = ownerVC
        self.pickedClosure = pickedClosure
    }
    
    //MARK: - Action
    func showActionWith(type: IStoreParaType, currentItem: String) {
        if isShow {
            self.dismiss()
        } else {
            self.type = type
            self.currentItem = currentItem
            sourceRequest()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    //MARK: - Request
    func sourceRequest() {
        WebTool.post(isShowHud: false, uri: uri, para: para, success: { (dict) in
            let model = IHistoryPickParaResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.dataArray = [self.allModel] + model.data
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
        // 刷新数据
        collectionView.reloadData()
        //collectionView高度
        let rowNumber = (dataArray.count % 3 == 0) ? dataArray.count / 3 : dataArray.count / 3 + 1
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
        let model = dataArray[indexPath.row]
        cell.setupData(type: type, model: model, currentItem: currentItem)
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //Cell尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth-15*4)/3
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
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! MHistoryPickCell
        //记录
        currentItem = cell.itemLabel.text!
        //回调
        pickedClosure(type, dataArray[indexPath.row])
        //消失
        dismiss()
        
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
    
    var currentItem = ""
    var ownerVC = UIViewController()
    var pickedClosure: (IStoreParaType, MHistoryPickParaModel)->Void = {_,_  in }
    
    var uri = ""
    var para: [String : String] = [:]
    
    var modelId = ""
    
    var type = IStoreParaType.source {
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
                para = ["model_id": modelId, "param_type":"0"]
            }
        }
    }
    
    var isShow = false
    
    //"所有"model，加在dataArray第一个
    let allModel: MHistoryPickParaModel = {
        let model = MHistoryPickParaModel()
        model.source_name = "所有来源"
        model.model_name = "所有型号"
        model.param_name = "所有参数"
        return model
    }()
    var dataArray: [MHistoryPickParaModel] = []
    
}

class MHistoryPickCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(itemLabel)
        
        contentView.layer.cornerRadius = 2
        contentView.clipsToBounds = true
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
    
    func setupData(type: IStoreParaType, model: MHistoryPickParaModel, currentItem: String) {
        switch type {
        //设置显示数据
        case .source:
            itemLabel.text = model.source_name
        case .phoneModel:
            itemLabel.text = model.model_name
        case .phonePara:
            itemLabel.text = model.param_name
        }
        //设置初始选中状态
        var item = ""
        switch type {
        case .source:
            item = model.source_name
        case .phoneModel:
            item = model.model_name
        case .phonePara:
            item = model.param_name
        }
        
        if currentItem == item {
            itemLabel.textColor = blue_3899F7
            contentView.backgroundColor = blue_EBF5FF
        }else {
            itemLabel.textColor = black_333333
            contentView.backgroundColor = gray_F0F0F0
        }
    }
    
    //MARK: - Properties
    lazy var itemLabel: UILabel = {
        let label = UILabel.init(frame: frame)
        label.font = font12
        return label
    }()
}


