//
//  SelectMusicRangeView.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/11/30.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit

class SelectMusicRangeView: UIView {

    fileprivate let leftBorderView = UIView()
    fileprivate let rightBorderView = UIView()
    fileprivate let leftTimeLabel = SelectMusicTimeLabel()
    fileprivate let rightTimeLabel = SelectMusicTimeLabel()
    fileprivate let msgLabel = UILabel()
    fileprivate let playRangeView = UIView()
    lazy var indicateProgressView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -5, width: 2, height: bounds.height + 10))
        view.backgroundColor = UIColor.white
        playRangeView.addSubview(view)
        return view
    }()
    var progress: CGFloat = 0 {
        didSet {
            indicateProgressView.frame.origin.x = bounds.width * progress
        }
    }
    var totalTime: CGFloat = 0
    var endMovedLeftRange: ((_ left: CGFloat) -> ())?
    var endMovedRightRange: ((_ rightTime: CGFloat) -> ())?
    
    fileprivate var leftBorderBeginX: CGFloat = 0
    fileprivate var rightBorderBeginX: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer.self)
        return true
    }
    
}
// MARK: - 事件响应
extension SelectMusicRangeView {
    @objc fileprivate func leftRangeMove(_ gesture: UIPanGestureRecognizer) {
        let movePoint = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            leftBorderBeginX = leftBorderView.frame.origin.x
        case .changed:
            guard verifyRange() else {return}
            leftBorderView.frame.origin.x = leftBorderBeginX + movePoint.x
            leftTimeLabel.timeSec = totalTime * (leftBorderView.frame.origin.x / bounds.width)
        case .ended:
            endMovedLeftRange?(leftBorderView.frame.origin.x / bounds.width)
            break
        default :
            break;
        }
    }
    @objc fileprivate func rightRangeMove(_ gesture: UIPanGestureRecognizer) {
        let movePoint = gesture.translation(in: self)
        switch gesture.state {
        case .began:
            rightBorderBeginX = rightBorderView.frame.origin.x
        case .changed:
            guard verifyRange() else {return}
            rightBorderView.frame.origin.x = rightBorderBeginX + movePoint.x
            rightTimeLabel.timeSec = totalTime * (rightBorderView.frame.origin.x / bounds.width)
        case .ended:
            if indicateProgressView.frame.maxX > rightBorderView.frame.maxX {
                indicateProgressView.frame.origin.x = rightBorderView.frame.origin.x
            }
            endMovedRightRange?(rightBorderView.frame.maxX / bounds.width)
            break
        default :
            break;
        }
    }
    fileprivate func verifyRange() -> Bool{
        return rightBorderView.frame.origin.x > leftBorderView.frame.origin.x
    }
}

// MARK: - 设置UI界面
extension SelectMusicRangeView {
    fileprivate func initialize() {
        backgroundColor = UIColor.lightGray
        setSelectRangeView()
    }
    fileprivate func setSelectRangeView() {
        // 选取范围Label
        msgLabel.frame = CGRect(x: 10, y: 0, width: 50, height: bounds.height)
        msgLabel.center.y = bounds.height * 0.5
        msgLabel.text = "选取范围"
        msgLabel.sizeToFit()
        msgLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(msgLabel)
        
        // 确认按钮
        let sureBtn = UIButton(frame: CGRect(x: frame.maxX - 50, y: 0, width:40 , height: bounds.height))
        sureBtn.titleLabel?.sizeToFit()
        sureBtn.setTitle("确认", for: .normal)
        sureBtn.setTitleColor(UIColor.black, for: .normal)
        addSubview(sureBtn)
        
        // 播放范围容器view
        playRangeView.frame = CGRect(x: msgLabel.frame.maxX + 10, y: 0, width: bounds.width - msgLabel.bounds.width - sureBtn.bounds.width - 10 - 10, height: bounds.height)
        addSubview(playRangeView)
        
        // 左右边界选取
        leftBorderView.frame = CGRect(x: 0, y: 0, width: 15, height: frame.height)
        rightBorderView.frame = CGRect(x: playRangeView.bounds.width - 15, y: 0, width: 15, height: frame.height)
        leftBorderView.backgroundColor = UIColor.blue
        rightBorderView.backgroundColor = UIColor.blue
        leftBorderView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(leftRangeMove(_:))))
        rightBorderView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(rightRangeMove(_:))))
        
        // 左右时间提示label
        leftTimeLabel.frame = CGRect(x: 0, y: -20, width: 40, height: 20)
        rightTimeLabel.frame = CGRect(x: 0, y: -20, width: 40, height: 20)
        leftTimeLabel.timeSec = 0
        rightTimeLabel.timeSec = totalTime
        leftBorderView.addSubview(leftTimeLabel)
        rightBorderView.addSubview(rightTimeLabel)
        playRangeView.addSubview(leftBorderView)
        playRangeView.addSubview(rightBorderView)
        
    }
    
}










