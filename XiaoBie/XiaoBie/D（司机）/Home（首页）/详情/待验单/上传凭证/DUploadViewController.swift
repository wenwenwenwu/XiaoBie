//
//  DUploadViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class DUploadViewController: UIViewController, UITextViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
        
        view.addSubview(whiteView1)
        whiteView1.addSubview(photoButtonView1)
        photoButtonView2.isHidden = true
        whiteView1.addSubview(photoButtonView2)
        photoButtonView3.isHidden = true
        whiteView1.addSubview(photoButtonView3)
        photoButtonView4.isHidden = true
        whiteView1.addSubview(photoButtonView4)
        whiteView1.addSubview(infoLabel1)
        infoLabel2.isHidden = true
        whiteView1.addSubview(infoLabel2)
        infoLabel3.isHidden = true
        whiteView1.addSubview(infoLabel3)
        infoLabel4.isHidden = true
        whiteView1.addSubview(infoLabel4)

        view.addSubview(whiteView2)
        whiteView2.addSubview(noteTextView)
        whiteView2.addSubview(placeHolderLabel)
        whiteView2.addSubview(playButton)
        whiteView2.addSubview(tapeButton)
        
        view.addSubview(whiteView3)
        whiteView3.addSubview(confirmButton)
        
        setupNavigationBar()
        setupFrame()

    }
    
    //MARK: - Event Response
    @objc func tapeButtonTouchDownAction() {
        noteTextView.resignFirstResponder()
        recordTool.beginRecord()
    }
    
    @objc func tapeButtonTouchUpAction() {
        recordTool.stopRecord()
    }
    
    @objc func playButtonAction() {
        recordTool.play()
    }
    
    @objc func confirmButtonAction() {
        guard !photoButtonView1.imageName.isEmpty && !photoButtonView2.imageName.isEmpty && !photoButtonView3.imageName.isEmpty && !photoButtonView4.imageName.isEmpty
            else {
            HudTool.showInfo(string: "必须上传四张照片")
            return
        }
        confirmRequest()
        
    }
    
    //MARK: - Request
    func confirmRequest() {
        let fileDictionary = ["credit_positive": photoButtonView1.imageName,
                              "credit_negative": photoButtonView2.imageName,
                              "work_order_img": photoButtonView3.imageName,
                              "customer_img": photoButtonView4.imageName,
                              "audio": recordTool.audioName]
        let fileNames = getJSONStringFromDictionary(dictionary: fileDictionary as NSDictionary)
        
        WebTool.get(uri:"order_evidence_upload", para:["file_names":fileNames,
                                                       "remark":noteTextView.text!,
                                                       "order_id":model.id], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            HudTool.showInfo(string: model.msg)
            if model.code == "0" {
                let payVC = DPayViewController()
                payVC.model = self.model
                self.navigationController?.pushViewController(payVC, animated: true)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {//回车
            textView.scrollsToTop = true
            textView.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Private Method
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.title = "上传凭证"
    }
    
    func setupFrame() {
        whiteView1.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(125)
        }
        
        photoButtonView1.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(spacing)
            make.width.height.equalTo(76)
        }
        
        photoButtonView2.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(photoButtonView1.snp.right).offset(spacing)
            make.width.height.equalTo(76)
        }
        
        photoButtonView3.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(photoButtonView2.snp.right).offset(spacing)
            make.width.height.equalTo(76)
        }
        
        photoButtonView4.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(photoButtonView3.snp.right).offset(spacing)
            make.width.height.equalTo(76)
        }
        
        infoLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(photoButtonView1.snp.bottom).offset(8)
            make.centerX.equalTo(photoButtonView1)
        }
        
        infoLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(photoButtonView2.snp.bottom).offset(8)
            make.centerX.equalTo(photoButtonView2)
        }
        
        infoLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(photoButtonView3.snp.bottom).offset(8)
            make.centerX.equalTo(photoButtonView3)
        }
        
        infoLabel4.snp.makeConstraints { (make) in
            make.top.equalTo(photoButtonView4.snp.bottom).offset(8)
            make.centerX.equalTo(photoButtonView4)
        }
        
        whiteView2.snp.makeConstraints { (make) in
            make.top.equalTo(whiteView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(13)
        }
        
        noteTextView.snp.makeConstraints { (make) in
            make.top.equalTo(placeHolderLabel).offset(-8)
            make.left.equalTo(placeHolderLabel).offset(-5)
            make.bottom.equalTo(playButton.snp.top).offset(-7)
            make.right.equalToSuperview().offset(-8)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.top.equalTo(75)
            make.left.equalTo(13)
            make.height.equalTo(0)
        }
        
        tapeButton.snp.makeConstraints { (make) in
            make.left.equalTo(spacing)
            make.bottom.equalTo(-17)
            make.width.height.equalTo(76)
        }
        
        whiteView3.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(11, 13, 10, 13))
        }
    }

    //MARK: - Properties
    var whiteView1: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    var whiteView2: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    var whiteView3: UIView = {
        let view = UIView()
        view.backgroundColor = white_FFFFFF
        return view
    }()
    
    lazy var photoButtonView1 = DPhotoButtonView.viewWith(uploadPara: "upload_order_evidence", uploadType: "credit_positive", uploadOrderId: model.id, ownVC: self) {
        self.photoButtonView2.isHidden = false
        self.infoLabel2.isHidden = false
    }
    
    lazy var photoButtonView2 = DPhotoButtonView.viewWith(uploadPara: "upload_order_evidence", uploadType: "credit_negative", uploadOrderId: model.id, ownVC: self) {
        self.photoButtonView3.isHidden = false
        self.infoLabel3.isHidden = false
    }
    
    lazy var photoButtonView3 = DPhotoButtonView.viewWith(uploadPara: "upload_order_evidence", uploadType: "work_order_img", uploadOrderId: model.id, ownVC: self) {
        self.photoButtonView4.isHidden = false
        self.infoLabel4.isHidden = false
    }
    
    lazy var photoButtonView4 = DPhotoButtonView.viewWith(uploadPara: "upload_order_evidence", uploadType: "customer_img", uploadOrderId: model.id, ownVC: self) {
    
    }
    
    lazy var infoLabel1: UILabel = {
        let label = UILabel()
        label.text = "身份证正面"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var infoLabel2: UILabel = {
        let label = UILabel()
        label.text = "身份证反面"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var infoLabel3: UILabel = {
        let label = UILabel()
        label.text = "工单照片"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var infoLabel4: UILabel = {
        let label = UILabel()
        label.text = "客户正面照"
        label.font = font12
        label.textColor = gray_999999
        return label
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "备注一些东西吧..."
        label.font = font14
        label.textColor = gray_999999
        return label
    }()
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.returnKeyType = .done
        textView.font = font14
        textView.textColor = black_333333
        return textView
    }()
    
    lazy var tapeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font12
        button.setTitle("长按录音", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_tape_white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(-6, 25, 6, -25)
        button.titleEdgeInsets = UIEdgeInsetsMake(20, -11, -20, 11)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.setBackgroundImage(blue_2f85d8.colorImage(), for: .highlighted)
        button.addTarget(self, action: #selector(tapeButtonTouchDownAction), for: .touchDown)
        button.addTarget(self, action: #selector(tapeButtonTouchUpAction), for: .touchUpInside)
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "icon_yyt"), for: .normal)
        button.addTarget(self, action: #selector(playButtonAction), for: .touchDown)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = font14
        button.setTitle("确认上传", for: .normal)
        button.setTitleColor(white_FFFFFF, for: .normal)
        button.setBackgroundImage(blue_3296FA.colorImage(), for: .normal)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var recordTool = RecordTool.toolWith(orderId: model.id) {
        self.whiteView2.snp.updateConstraints { (make) in
            make.height.equalTo(208)
        }
        self.playButton.snp.updateConstraints { (make) in
            make.height.equalTo(30)
        }
    }
    
    var model = DGrabItemModel()
    
    let spacing = (screenWidth-76*4)/5
}
