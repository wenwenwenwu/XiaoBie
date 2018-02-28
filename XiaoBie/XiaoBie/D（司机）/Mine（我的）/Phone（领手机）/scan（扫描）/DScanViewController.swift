//
//  DScanViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/02/23.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit
import AVFoundation

class DScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
        view.addSubview(blurView)
        view.addSubview(backButton)
        view.addSubview(infoLabel)
        view.addSubview(hornImageView)
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        print("🐱")
    }
    
    //MARK：Setup
    func setupCamera() {
        do{
            //device
            device = AVCaptureDevice.default(for: AVMediaType.video)
            
            //input
            input = try AVCaptureDeviceInput(device: device)
            
            //output
            output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //session
            session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                session.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
               session.sessionPreset = AVCaptureSession.Preset.high
            }
            session.addInput(self.input)
            session.addOutput(self.output)
            
            //output进一步设置(一定要放在session设置完成之后)
            //metadataObjectTypes
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,
                                               AVMetadataObject.ObjectType.ean8,
                                               AVMetadataObject.ObjectType.code128,
                                               AVMetadataObject.ObjectType.code39,
                                               AVMetadataObject.ObjectType.code93]
            
            //rectOfInterest
            //扫描范围(CGRect(y,x,h,w)).反的且为比例.默认值为(0,0,1,1)代表全屏
            let rectOfInterest = CGRect(x:scanRect.origin.y/screenHeight,
                              y:scanRect.origin.x/screenWidth,
                              width:scanRect.size.height/screenHeight,
                              height:scanRect.size.width/screenWidth)
            output.rectOfInterest = rectOfInterest
            
            //preview
            preview = AVCaptureVideoPreviewLayer(session:session)
            preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            preview.frame = UIScreen.main.bounds
            view.layer.insertSublayer(preview, at:0)
            
            //开始捕获
            session.startRunning()
            
            //放大
            do {
                try device.lockForConfiguration()
            } catch _ {
                NSLog("Error: lockForConfiguration.");
            }
            device.videoZoomFactor = 1.5
            device.unlockForConfiguration()
            
        }catch _ as NSError{
            Alert.showAlertWith(style: .alert, controller: self, title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", buttons: ["确定"], closure: { _ in })
        }
    }
    
    //MARK: - Request
    func claimPhoneRequest(serialNumber: String) {
        let staffId = AccountTool.userInfo().id

        WebTool.post(uri: "claim_phone_delivery", para: ["staff_id" : staffId, "serial_no" : serialNumber], success: { (dict) in
            let model = DBasicResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.scanedClosure(serialNumber)
                self.navigationController?.popViewController(animated: true)
            } else {
                HudTool.showInfo(string: model.msg, closure: {
                    self.session.startRunning()
                })
            }
        }) { (error) in
            HudTool.showInfo(string: error, closure: {
                self.session.startRunning()
            })
        }
    }
    
    //MARK: - Event Response
    @objc func backButtonAction()  {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        var serialNumber:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            serialNumber = metadataObject.stringValue
            if serialNumber != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        //录入序列号
        claimPhoneRequest(serialNumber: serialNumber!)
    }
    
    //MARK: - Properties
    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 15, y: 35, width: 14, height: 28)
        button.setBackgroundImage(#imageLiteral(resourceName: "icon_wreturn"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: (screenWidth-150)/2, y: scanRect.minY-60, width: 150, height: 25))
        label.backgroundColor = black_40
        label.textAlignment = .center
        label.text = "将条形码放入框内"
        label.textColor = white_FFFFFF
        label.font = font14
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    lazy var blurView:UIView = {
        let view = UIView.init(frame: screenBounds)
        view.backgroundColor = black_40
        let path = UIBezierPath(rect:screenBounds)
        path.append(UIBezierPath(rect: scanRect).reversing())
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        view.layer.mask = shape
        return view
    }()
    
    lazy var hornImageView: UIImageView = {
        let imageView = UIImageView.init(frame: scanRect)
        imageView.image = #imageLiteral(resourceName: "img_scanninghorn")
        return imageView
    }()
    
    lazy var scanRect: CGRect = {
        let scanSize = CGSize(width:screenWidth*3/4,
                              height:screenWidth*3/4)
        let scanRect = CGRect(x:(screenWidth-scanSize.width)/2,
                          y:(screenHeight-scanSize.height)/2,
                          width:scanSize.width, height:scanSize.height)
        return scanRect
    }()
    
    override var prefersStatusBarHidden: Bool {get { return true } }//隐藏状态栏
    
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var scanedClosure:(String)->() = {_ in }
}
