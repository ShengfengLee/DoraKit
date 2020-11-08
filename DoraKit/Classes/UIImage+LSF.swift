//
//  UIImage+LSF.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/18.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public extension UIImage {
    
    ///通过UIColor 生成图片
    static func lsf_image(color:UIColor, size:CGSize = CGSize.init(width: 1, height: 1)) -> UIImage? {
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    ///圆角图片
    func lsf_radiusImage(_ cornerRadius: CGFloat? = nil) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        var radius: CGFloat
        if cornerRadius == nil {
            radius = min(rect.size.width, rect.size.height) / 2
        }
        else {
            radius = cornerRadius!
        }
        UIBezierPath.init(roundedRect: rect, cornerRadius: radius).addClip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //*
    func lsf_fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform : CGAffineTransform = CGAffineTransform.identity
        
        switch  self.imageOrientation {
        case .down, .downMirrored:  // EXIF = 3, 4
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:   // EXIF = 6, 5
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            
            
        case .right, .rightMirrored:    // EXIF = 8, 7
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2.0)
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:    // EXIF = 2, 4
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored: //EXIF = 5, 7
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break
        }
        
        let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let cgimg = ctx?.makeImage()
        let img = UIImage.init(cgImage: cgimg!)
        
        return img
        
    }

    ///裁剪正方形图片
    func lsf_squal() -> UIImage? {

        if size.width == size.height {
            return self
        }

        //新的image宽度
        let squalWidth = min(size.width, size.height)

        let rect = CGRect(x: (squalWidth - size.width) / 2,
                          y: (squalWidth - size.height) / 2,
                          width: size.width,
                          height: size.height)


        UIGraphicsBeginImageContext(CGSize(width: squalWidth, height: squalWidth))
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    ///正方形圆角图片
    func lsf_squalAndRadius(_ cornerRadius: CGFloat? = nil) -> UIImage? {
        //新的image宽度
        let squalWidth = min(size.width, size.height)
        
        let rect = CGRect(x: (squalWidth - size.width) / 2,
                          y: (squalWidth - size.height) / 2,
                          width: size.width,
                          height: size.height)
        
        
        UIGraphicsBeginImageContext(CGSize(width: squalWidth, height: squalWidth))

        let radius = cornerRadius ?? squalWidth / 2
        UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: squalWidth, height: squalWidth), cornerRadius: radius).addClip()

        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
 
 // */
}

