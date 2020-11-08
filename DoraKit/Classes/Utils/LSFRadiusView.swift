//
//  LSFRadiusView.swift
//  yoyo
//
//  Created by 李胜锋 on 2018/12/6.
//  Copyright © 2018 Yalla. All rights reserved.
//

import Foundation
import UIKit

public class LSFRadiusView: UIView {
    @IBInspectable var topLeftRadius: Bool = false
    @IBInspectable var topRightRadius: Bool = false
    @IBInspectable var bottomLeftRadius: Bool = false
    @IBInspectable var bottomRightRadius: Bool = false
    @IBInspectable var lsfCornerRadius: CGFloat = 0

    
    @IBInspectable var topLeftR: CGFloat = 0
    @IBInspectable var topRightR: CGFloat = 0
    @IBInspectable var bottomLeftR: CGFloat = 0
    @IBInspectable var bottomRightR: CGFloat = 0

    
    public override func layoutSubviews() {
        super.layoutSubviews()

        if self.bounds.size.width == 0 { return }
        if self.bounds.size.height == 0 { return }
        self.maskview()
        self.drawiMask()
    }

    //相同的圆角
    public  func maskview() {

        if lsfCornerRadius <= 0 {
            return
        }
        if topLeftRadius || topRightRadius || bottomLeftRadius || bottomRightRadius {

            var corners: UIRectCorner = []
            if bottomLeftRadius {
                corners.insert(UIRectCorner.bottomLeft)
            }
            if bottomRightRadius {
                corners.insert(UIRectCorner.bottomRight)
            }
            if topLeftRadius {
                corners.insert(UIRectCorner.topLeft)
            }
            if topRightRadius {
                corners.insert(UIRectCorner.topRight)
            }
            let cornerRadii = CGSize(width: lsfCornerRadius, height: lsfCornerRadius)
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)

            let shapLayer = CAShapeLayer()
            shapLayer.path = path.cgPath
            self.layer.mask = shapLayer
        }
    }


    ///画四个不同圆角
    public func drawiMask() {
        if topLeftR == 0, topRightR == 0, bottomLeftR == 0, bottomRightR == 0 {
            return
        }

        let path = UIBezierPath()

        let width = self.bounds.size.width
        let height = self.bounds.size.height
        path.move(to: CGPoint(x: width / 2, y: 0))


        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY

        //右上角圆角
        if topRightR > 0 {

            let topRightCenterX = maxX - topRightR
            let topRightCenterY = minY + topRightR

            path.addArc(withCenter: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: topRightR, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi * 2, clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: width, y: 0))
        }

        //右下角圆角
        if bottomRightR > 0 {

            let bottomRightCenterX = maxX - bottomRightR
            let bottomRightCenterY = maxY - bottomRightR

            path.addArc(withCenter: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: bottomRightR, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: width, y: height))
        }


        //左下角圆角
        if bottomLeftR > 0 {

            let bottomLeftCenterX = minX + bottomLeftR
            let bottomLeftCenterY = maxY - bottomLeftR

            path.addArc(withCenter: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: bottomLeftR, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: 0, y: height))
        }


        //左上角圆角
        if topLeftR > 0 {

            let topLeftCenterX = minX + topLeftR
            let topLeftCenterY = minY + topLeftR

            path.addArc(withCenter: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: topLeftR, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: 0, y: 0))
        }


        path.close()

        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        self.layer.mask = shapLayer
    }
}

