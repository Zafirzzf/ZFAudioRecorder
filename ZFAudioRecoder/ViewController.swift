//
//  ViewController.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/28.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var recordProgress: UIProgressView!
    fileprivate let recoder = ZFAudioRecoder()

   
    @IBOutlet weak var backmusicLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }



}
// MARK: - 事件响应
extension ViewController {
  
    @IBAction func touchDownRecord(_ sender: UIButton) {
        recoder.startRecoder(0)
    }
    @IBAction func touchUpRecord(_ sender: UIButton) {
        recoder.endRecoder()
    }
    @IBAction func playClick(_ sender: UIButton) {
        recoder.playCurrentRecoder()
    }
    @IBAction func revocationClick(_ sender: UIButton) {
        recoder.deleteLastRecord()
    }
    @IBAction func addBackMusic(_ sender: UIButton) {
        navigationController?.pushViewController(SelectBackMusicVC(), animated: true)
    }
    
}

