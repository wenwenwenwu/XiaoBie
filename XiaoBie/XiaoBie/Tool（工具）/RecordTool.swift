//
//  RecordTool.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/3/6.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class RecordTool {
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let file_path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/record.wav")

    //MARK: - Factory Method
    class func toolWith(uploadPara: String, model: DGrabItemModel, sucessClosure: @escaping ()->Void, failureClosure: @escaping ()->Void) -> RecordTool {
        let tool = RecordTool()
        tool.uploadPara = uploadPara
        tool.sucessClosure = sucessClosure
        tool.failureClosure = failureClosure
        tool.model = model
        return tool        
    }
    
    //MARK: - Request
    func upLoadAudioRequest(localURL: URL, orderId: String) {
        //传音频
        WebTool.upLoadAudio(orderId: orderId, audioURL: localURL, success: { (dict) in
            let model = PicturesResponseModel.parse(dict: dict)
            if model.code == "0" {
                self.audioName = model.data[0]
                HudTool.showInfo(string: "音频上传成功")
            } else {
                HudTool.showInfo(string: model.msg)
            }
        }) { (error) in
            HudTool.showInfo(string: error)
        }
    }
    
    //MARK: - Event Response
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式（wav）
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                let localURL = URL(fileURLWithPath:file_path!)
                upLoadAudioRequest(localURL: localURL, orderId: model.id)
                print("正在录音，马上结束它，文件保存到了：\(file_path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
        
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            print("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    //MARK: - Properties
    var uploadPara = ""
    var audioName = ""
    var sucessClosure: ()->Void = {}
    var failureClosure: ()->Void = {}
    var model = DGrabItemModel()
    
    
}
