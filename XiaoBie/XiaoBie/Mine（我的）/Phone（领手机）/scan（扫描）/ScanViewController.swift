//
//  ScanViewController.swift
//  PostOfficeAdmain
//
//  Created by wuwenwen on 2018/02/23.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = gray_F5F5F5
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
    
    //MARK：Setup
    func setupCamera() {
        do{
            //device
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
            
            //input
            self.input = try AVCaptureDeviceInput(device: device)
            
            //output
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //session
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
                self.session.sessionPreset = AVCaptureSession.Preset.high
            }
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,
                                               AVMetadataObject.ObjectType.ean8,
                                               AVMetadataObject.ObjectType.code128,
                                               AVMetadataObject.ObjectType.code39,
                                               AVMetadataObject.ObjectType.code93]
            
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size;
            let scanSize = CGSize(width:windowSize.width*3/4,
                                  height:windowSize.width*3/4)
            var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                                  y:(windowSize.height-scanSize.height)/2,
                                  width:scanSize.width, height:scanSize.height)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width)
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x:0, y:0, width:scanSize.width,
                                             height:scanSize.height)
            self.scanRectView.center = CGPoint(x:UIScreen.main.bounds.midX,
                                               y:UIScreen.main.bounds.midY)
            self.scanRectView.layer.borderColor = UIColor.green.cgColor
            self.scanRectView.layer.borderWidth = 1
            
            //开始捕获
            self.session.startRunning()
            
            //放大
            do {
                try self.device!.lockForConfiguration()
            } catch _ {
                NSLog("Error: lockForConfiguration.");
            }
            self.device!.videoZoomFactor = 1.5
            self.device!.unlockForConfiguration()
        }catch _ as NSError{
            Alert.showAlertWith(style: .alert, controller: self, title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", buttons: ["确定"], closure: { (title) in
                print(title)
            })
        }
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        //输出结果
        let alertController = UIAlertController(title: "二维码",
                                                message: stringValue,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            //继续扫描
            self.session.startRunning()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Properties
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var scanedClosure:(String)->() = {_ in }
}
