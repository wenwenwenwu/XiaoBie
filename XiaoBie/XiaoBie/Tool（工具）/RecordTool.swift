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
    
    //MARK: - Factory Method
    class func toolWith(orderId: String, recordAndUploadSucessClosure: @escaping ()->Void) -> RecordTool {
        let tool = RecordTool()
        tool.orderId = orderId
        tool.recordAndUploadSucessClosure = recordAndUploadSucessClosure
        return tool
    }
    
    //MARK: - Request
    func upLoadAudioRequest(localURL: URL, orderId: String) {
        //传音频
        WebTool.upLoadAudio(orderId: orderId, audioURL: localURL, success: { (dict) in
            let model = PicturesResponseModel.parse(dict: dict)
            if model.code == "0" {
                //弹窗
                HudTool.showInfo(string: "音频上传成功")
                //属性设置
                self.audioName = model.data[0]
                //成功回调
                self.recordAndUploadSucessClosure()
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
            HudTool.showInfo(string: "设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            HudTool.showInfo(string: "初始化动作失败:\(err.localizedDescription)")
        }
        //设置扬声器模式
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let  err{
            HudTool.showInfo(string: "扬声器设置失败:\(err.localizedDescription)")
        }
        //录音设置（后面需要转换成NSNumber，如果不转换则无法录制音频文件，大概是因为底层还是用OC写的原因）
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
            HudTool.showInfo(string: "录音失败:\(err.localizedDescription)")
        }
    }
    
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                let localURL = URL(fileURLWithPath:file_path!)
                print("录音结束，文件保存到了：\(file_path!)，立刻开始上传")
                upLoadAudioRequest(localURL: localURL, orderId: orderId)
            }else {
                HudTool.showInfo(string: "没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            HudTool.showInfo(string: "没有初始化")
        }
    }
        
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            print("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            HudTool.showInfo(string: "播放失败:\(err.localizedDescription)")
        }
    }
    
    //MARK: - Properties
    var orderId = ""
    var recordAndUploadSucessClosure: ()->Void = {}
    
    var audioName = ""
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let file_path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/record.wav")
}
