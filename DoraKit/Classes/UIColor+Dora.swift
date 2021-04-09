//
//  UIColor+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/2.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit


public extension UIColor {

    
    static func dora_color16(_ rgb:Int, alpha:CGFloat) -> UIColor {
        
        return UIColor.init(red: ((CGFloat)((rgb & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgb & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgb & 0xFF))/255.0, alpha: alpha)
    }
    
    static func dora_color16(_ rgb:Int) -> UIColor {
        return dora_color16(rgb, alpha: 1.0)
    }
    
}
