//
//  SelectBackMusicVC.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/30.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
import AVFoundation
fileprivate let KSelectViewHeight:CGFloat = 100
class SelectBackMusicVC: UITableViewController {

    fileprivate lazy var selMusicView: SelectMusicRangeView  = {
        let selView = SelectMusicRangeView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-64, width: UIScreen.main.bounds.width, height: KSelectViewHeight))
        selView.endMovedLeftRange = { left in
            self.player.playToProgress(left)
            self.timeUpdate()
        }
        selView.endMovedRightRange = { right in
            self.rightBorderProgerss = right
        }
        return selView
    }()
    fileprivate var player = ZFAudioPlayer()
    fileprivate lazy var timer = Timer()
    var musicNameList = [String]()
    var musicPathList = [String]()
    
    fileprivate var rightBorderProgerss: CGFloat = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocalMusic()
    }

}

extension SelectBackMusicVC {
    fileprivate func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    @objc fileprivate func timeUpdate() {
        if player.isPlaying {
            selMusicView.progress = player.progress
            if player.progress >= rightBorderProgerss {
                player.pausePlay()
            }
        }
    }
    fileprivate func loadLocalMusic() {
        DispatchQueue.global().async {
            let musicDirectory =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/BackMusic"
            let directoryEnum = FileManager.default.enumerator(atPath: musicDirectory)
            for directory in directoryEnum! {
                let musicName = (directory as! String).components(separatedBy: ".").first!
                self.musicNameList.append(musicName)
                let musicPath = musicDirectory + "/\(directory)"
                self.musicPathList.append(musicPath)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SelectBackMusicVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicNameList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil  {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text = musicNameList[indexPath.row]
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        player.playLocalAudio(URL(fileURLWithPath: musicPathList[indexPath.row]))
        presentSelMusicView()
        selMusicView.totalTime = player.duration
    }
}



// MARK: - 抽取的方法
extension SelectBackMusicVC {
    
    fileprivate func presentSelMusicView() {
        if !timer.isValid {
            addTimer()
        }
        view.addSubview(selMusicView)
        UIView.animate(withDuration: 0.25) {
            self.selMusicView.frame.origin.y = UIScreen.main.bounds.height - KSelectViewHeight - 64
        }
    }
}
