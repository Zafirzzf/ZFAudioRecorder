//
//  ZFAudioRecoder.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/28.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
import AVFoundation
enum ZFRecorderErr: Error {
    case initalRecoderError
}
/// 这是一个刻意为"多段录音"所服务的类. 类似抖音的音频录制版.
class ZFAudioRecoder {
    
    init() {
        settingAudioSession()
    }
    fileprivate lazy var player = ZFAudioPlayer()
    fileprivate lazy var fileTool = ZFAudioFileTool()
    /// 存放多段录音器的数组
    fileprivate lazy var recoders = [AVAudioRecorder]()
    
    fileprivate var recordSettings:[String: Any] = {
        // 2. 设置录音参数
        var recordSettings = [String:Any]()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC // 编码格式
        recordSettings[AVSampleRateKey] = 11025.0 // 采样率
        recordSettings[AVNumberOfChannelsKey] = 1 // 通道数
        recordSettings[AVEncoderAudioQualityKey] = kRenderQuality_Min // 音频质量
        return recordSettings
    }()
}

// MARK: - 对外提供的API
extension ZFAudioRecoder {
    /// 开始录音
    func startRecoder(_ stageNum: Int) {
        let recorder = try! AVAudioRecorder(url: fileTool.createOneStageRecordPath(recoders.count), settings: recordSettings)
        recorder.isMeteringEnabled = true
        recoders.append(recorder)
        recoders.last!.record()
        
    }
    /// 暂停录音
    func pauseRecoder() {
        recoders.last!.pause()
    }
    /// 结束录音
    func endRecoder() {
        recoders.last!.stop()


    }
    
    /// 删除最后一段录音
    func deleteLastRecord() {
        fileTool.deletePreviousAudio(recoders)
        recoders.removeLast()
    }
    /// 播放录音
    func playCurrentRecoder() {
        guard recoders.count > 0 else {return}
        if recoders.count > 1 {
            fileTool.combineRecoder(recoders, completed: {
                print("合成完毕")
                
                self.player.playLocalAudio(URL(fileURLWithPath: self.fileTool.tempRecoderPath + "/combine\(self.recoders.count).m4a"))
            })
        }else {
            self.player.playLocalAudio(URL(fileURLWithPath: self.fileTool.tempRecoderPath + "/temp0.m4a"))
        }
        
    }
    
    
}
// MARK: - 方法抽取
extension ZFAudioRecoder {
    fileprivate func settingAudioSession() {
        // category参数的含义,options?
        try?AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)//录音时候允许播放
        try?AVAudioSession.sharedInstance().setActive(true)
    }
}








