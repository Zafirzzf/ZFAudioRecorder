//
//  ZFAudioFileTool.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/28.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
import AVFoundation
fileprivate let KTempDirectory = NSTemporaryDirectory() + "ZFAudioRecoder"
class ZFAudioFileTool: NSObject {
     var tempRecoderPath: String = {
        if !FileManager.default.fileExists(atPath: KTempDirectory) {
            try!FileManager.default.createDirectory(at: URL(fileURLWithPath: KTempDirectory, isDirectory: true), withIntermediateDirectories: true, attributes: nil)
        }
        return KTempDirectory
    }()
    
    
}

// MARK: - 对外提供方法
extension ZFAudioFileTool {
    // 录某一段的路径
     func createOneStageRecordPath(_ stageNum: Int) -> URL{
        let path = tempRecoderPath + "/temp\(stageNum).m4a"
        return URL(fileURLWithPath: path)
    }
    
    // 合并录制的音频
    func combineRecoder(_ recoders: [AVAudioRecorder], completed:@escaping () -> ()) {
        
        let outputPath = tempRecoderPath + "/combine\(recoders.count).m4a"
        combineAllRecorder(recoders,outputPath, completed: completed)
    }
    /// 删除上一段视频
    func deletePreviousAudio(_ recoders: [AVAudioRecorder]) {
        let recoderCount = recoders.count
        try?FileManager.default.removeItem(atPath: tempRecoderPath + "/temp\(recoderCount - 1).m4a")
        try?FileManager.default.removeItem(atPath: tempRecoderPath + "/combine\(recoderCount).m4a")
        
    }
    
   
}
// MARK: - 方法抽取
extension ZFAudioFileTool {
    /// 合并多段音频
    fileprivate func combineAllRecorder(_ recoders: [AVAudioRecorder],_ outputPath: String, completed:@escaping() -> ()) {
        guard recoders.count > 1 else {return;}
        let composition = AVMutableComposition()
        let mutableTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        var insertTime = kCMTimeZero
        for recorder in recoders {
            let asset = AVURLAsset(url: recorder.url)
            let track = asset.tracks(withMediaType: .audio)
            try?mutableTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: track.first!, at: insertTime)
            insertTime = insertTime + asset.duration
        }
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = URL(fileURLWithPath: outputPath)
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completed()
            }
        }
    }
    
    // 将某一段加到另一段的后面
    fileprivate func combineAudio(fromUrl: URL, toUrl: URL, outputPath: String, completed: @escaping () -> ()) {
        let asset2 = AVURLAsset(url: fromUrl)
        let asset1 = AVURLAsset(url: toUrl)
        let track2 = asset2.tracks(withMediaType: .audio).first!
        let track1 = asset1.tracks(withMediaType: .audio).first!
        
        let composition = AVMutableComposition()
        let mutableTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        try!mutableTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset1.duration), of: track1, at: kCMTimeZero)
        try!mutableTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset2.duration), of: track2, at: asset1.duration)
        
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = URL(fileURLWithPath: outputPath)
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completed()
            }
        }
    }
}

