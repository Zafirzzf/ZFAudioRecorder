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
    
     var player: AVAudioPlayer?
    
    
    /// 是否正在播放
    var isPlaying: Bool {
        get {
            return player?.isPlaying ?? false
        }
    }
    /// 播放进度
    var progress: CGFloat  {
        get {
            guard let player = player else {return 0}
            return CGFloat(player.currentTime / player.duration)
        }
    }
    /// 播放总时长
    var duration: CGFloat {
        get {
            guard let player = player else {return 0}
            return CGFloat(player.duration)
        }
    }
}

// MARK: - 对外提供方法
extension ZFAudioPlayer {
    func playLocalAudio(_ url: URL) {
        guard let player = try?AVAudioPlayer(contentsOf: url) else {return}
        self.player = player
        player.play()
    }
    
    func pausePlay() {
        guard let player = player else {return}
        player.pause()
    }
    
    func playToTimeOffset(_ timeOffset: CGFloat) {
        guard let player = player else {return}
        player.currentTime = TimeInterval(timeOffset)
        player.play()
    }
    func playToProgress(_ progress: CGFloat) {
        guard let player = player else {return}
        player.currentTime = player.duration * TimeInterval(progress)
        player.play()
    }

    func stopPlay() {
        guard let player = player else {return}
        player.stop()
    }
}
