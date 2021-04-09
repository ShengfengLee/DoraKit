//
//  DoraCircleProgressView.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/10/10.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit

///自定义彩色圆形进度条
public class DoraCircleProgressView : UIView {
    public var progress:CGFloat = 0
    public var lineWidth:CGFloat = 12.0
    
    public var fillColor:UIColor = UIColor.clear
    public var trackColor:UIColor = UIColor.lightGray
    public var progressColor:UIColor = UIColor.red
    
    public var trackLayer:CAShapeLayer?
    public var progressLayer:CAShapeLayer?
    
    public func setProgress(_ progress:CGFloat, animated:Bool = false) {
        self.progress = progress
        self.drawTrackLayer()
        self.drawProgressLayer()
        
//        CATransaction.setDisableActions(!animated)
        let function = CAMediaTimingFunctionName.easeIn
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: function))
//        CATransaction.setAnimationDuration(5)
        
        CATransaction.begin()
        progressLayer?.strokeEnd = progress
        CATransaction.commit()
        
    }
    
    
    // 背景圆
    private func drawTrackLayer() {
        
        if trackLayer != nil {
            trackLayer?.removeFromSuperlayer()
            trackLayer = nil
        }
        
        trackLayer = self.drawLayer(strokeColor: trackColor)
        trackLayer?.fillColor = fillColor.cgColor
        self.layer.insertSublayer(trackLayer!, at: 0)
//        self.layer.addSublayer(trackLayer!)
    }
    
    //进度圆
    private func drawProgressLayer() {
        
        if progressLayer != nil {
            progressLayer?.removeFromSuperlayer()
            progressLayer = nil
        }
        
        // 1.画背景圆
        progressLayer = self.drawLayer(strokeColor: progressColor)
        progressLayer?.strokeEnd = 0.0
        self.layer.addSublayer(progressLayer!)
    }
    
    //画圆圈
    private func drawLayer(strokeColor:UIColor) -> CAShapeLayer {
        var layer:CAShapeLayer
        
        // 1.画背景圆
        let center = CGPoint.init(x: self.dora_width / 2.0, y: self.dora_height / 2.0)
        let radius = (self.dora_width - lineWidth) / 2.0
        
        let path = UIBezierPath.init(arcCenter: center,
                                     radius: radius,
                                     startAngle: CGFloat.pi / 180 * -90,
                                     endAngle: CGFloat.pi / 180 * (360 - 90),
                                     clockwise: true)
        
        layer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.opacity = 1
        layer.lineCap = CAShapeLayerLineCap.round
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
    
        return layer
    }
}
