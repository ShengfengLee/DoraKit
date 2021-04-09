//
//  UIButton+Dora.swift
//  Exam-iOS
//
//  Created by 李胜锋 on 2018/2/27.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 倒计时
public extension UIButton {
    
    //button上下布局
    func dora_vertical(space: CGFloat) {
        guard let imgView = self.imageView, let label = self.titleLabel else { return }
 
        label.textAlignment = .center
        //*
        let imgSize = imgView.bounds.size
//        let imageSize = imgView.image?.size ?? CGSize.zero
        let labelSize = label.intrinsicContentSize
        
        let imgEdgeInsets = UIEdgeInsets(top: 0 - labelSize.height - space / 2,
                                         left: labelSize.width,
                                         bottom: 0,
                                         right: 0)
        
        let labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0 - imgSize.width,
            //left: (self.bounds.size.width - labelSize.width) / 2.0,
                                           bottom: 0 - imgSize.height - space / 2,
                                           right: 0)
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imgEdgeInsets
        // */
    }
    
    
    func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        var remainingCount: Int = count {
            willSet {
                setTitle("重新发送(\(newValue))", for: .normal)
                
                if newValue <= 0 {
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}

