//
//  MHistoryPickPopView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/16.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

enum MHistoryPickParaType {
    case source
    case phoneModel
    case phonePara
}

class MHistoryPickPopView: UIView, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

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
    class func showPopViewWith(ownerController: UIViewController, paraType: MHistoryPickParaType, dataArray: [MHistoryPickParaModel], pickedClosure:  @escaping (MHistoryPickParaType,String)->Void) {
        let popView = MHistoryPickPopView.init(frame: CGRect.init(x: 0, y: 40, width: screenWidth, height: screenHeight-navigationBarHeight-40))
        popView.pickedClosure = pickedClosure
        popView.dataArray = dataArray
        //动画
        //collectionView高度
        let rowNumber = dataArray.count/4+1        
        let height = 15 * (rowNumber + 1) + 30 * rowNumber
        
        UIView.animate(withDuration: animationTime) {
            popView.collectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: CGFloat(height))
        }
        //记录状态
        popView.isShow = true
        //加载
        ownerController.view.addSubview(popView)
        
    }
    
    //MARK: - Event Response
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    //MARK: - Action Method
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
        cell.setupData(type: pickParaType, model: dataArray[indexPath.row])
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
        pickedClosure(pickParaType, cell.itemLabel.text!)
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
    
    var pickedClosure: (MHistoryPickParaType, String)->Void = {_,_  in }
    var pickParaType = MHistoryPickParaType.source
    
    var isShow = false
    
    var dataArray: [MHistoryPickParaModel] = []
}
