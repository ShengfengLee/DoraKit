//
//  UIView+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/22.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    
    //获取view所在的ViewController
    func getFirstViewController()->UIViewController?{
        
        for view in sequence(first: self.superview, next: {$0?.superview}){
            
            if let responder = view?.next{
                
                if responder.isKind(of: UIViewController.self){
                    
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    static func dora_safeAreaInsets() -> UIEdgeInsets{
        var edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow ?? UIWindow()
            edge = window.safeAreaInsets
        }
        
        return edge
    }
    
    ///设置渐变色
    func dora_gradientColor(colors: [CGColor],
                           frame: CGRect? = nil,
                           startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                           endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                           locations: [NSNumber]? = nil,
                           cornerRadius: CGFloat? = nil) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        if let frame = frame {
            gradientLayer.frame = frame
        }
        else {
            let rect = self.bounds
            gradientLayer.frame = rect
        }
        
        if locations != nil {
            gradientLayer.locations = locations
        }
        //圆角
        if let cornerRadius = cornerRadius {
            gradientLayer.masksToBounds = true
            gradientLayer.cornerRadius = cornerRadius
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///设置部分圆角
    func dora_addRoundedCorners(corners: UIRectCorner, radii: CGSize, rect: CGRect) {
        
        let rounded = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        layer.mask = shape
    }
}

///添加边框
public extension UIView {
    ///添加边框
    func dora_border(rect: CGRect,
                    lineWidth: CGFloat,
                    color: UIColor,
                    top: Bool = false,
                    left: Bool = false,
                    bottom:  Bool = false,
                    right:  Bool = false) {
        let bezierPath = UIBezierPath()
        
        //上
        if top {
            bezierPath.move(to: CGPoint(x: 0, y: 0))
            bezierPath.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        
        //左
        if left {
            bezierPath.move(to: CGPoint(x: 0, y: 0))
            bezierPath.addLine(to: CGPoint(x: 0, y: rect.height))
        }
        
        //下
        if top {
            bezierPath.move(to: CGPoint(x: 0, y: rect.height))
            bezierPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        }
        
        //右
        if top {
            bezierPath.move(to: CGPoint(x: rect.width, y: 0))
            bezierPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        }
        
        let shapeLayper = CAShapeLayer()
        shapeLayper.strokeColor = color.cgColor
        shapeLayper.fillColor = UIColor.clear.cgColor
        shapeLayper.path = bezierPath.cgPath
        shapeLayper.lineWidth = lineWidth
        
        self.layer.addSublayer(shapeLayper)
        
    }
}

// MARK: - View 属性便捷访问
public extension UIView {
    var dora_x:CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var dora_y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var dora_centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set {
            self.center.x = newValue
        }
    }
    
    var dora_centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set {
            self.center.y = newValue
        }
    }
    
    var dora_width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame.size.width = newValue
        }
    }
    
    var dora_height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame.size.height = newValue
        }
    }
    
    
    var dora_right:CGFloat {
        get {
            return self.frame.maxX
        }
        
        set {
            self.dora_x = newValue - self.dora_width
        }
    }
    
    var dora_bottom:CGFloat {
        get {
            return self.frame.maxY
        }
        
        set {
            self.dora_y = newValue - self.dora_height
         }
    }
    
    var dora_size:CGSize {
        get {
            return self.frame.size
        }
        
        set {
            self.frame.size = newValue
        }
    }
    
}

// MARK: - UIView链式UI代码
public protocol ViewChainable {}
public extension ViewChainable where Self:UIView {
    @discardableResult
    func config(_ config: (Self)->Void ) -> Self {
        config(self)
        return self
    }
}

extension UIView:ViewChainable {
    public func add(to supereView: UIView) -> Self {
        supereView.addSubview(self)
        return self
    }
}



public extension UIView {
    ///截图，将UIView转化成Image
    func dora_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
