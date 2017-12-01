//
//  ZFAudioPlay.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/29.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
import AVFoundation
class ZFAudioPlayer {
    
    fileprivate var player = AVAudioPlayer()
    
    
    /// 是否正在播放
    var isPlaying: Bool {
        get {
            return player.isPlaying
        }
    }
    /// 播放进度
    var progress: CGFloat  {
        get {
            return CGFloat(player.currentTime / player.duration)
        }
    }
    /// 播放总时长
    var duration: CGFloat {
        get {
            return CGFloat(player.duration)
        }
    }
}

// MARK: - 对外提供方法
extension ZFAudioPlayer {
    func playLocalAudio(_ url: URL) {
        
        player = try!AVAudioPlayer(contentsOf: url)
        player.play()
    }
    func pausePlay() {
        player.pause()
    }
    func playToProgress(_ progress: CGFloat) {
        player.currentTime = player.duration * TimeInterval(progress)
        player.play()
    }
}
