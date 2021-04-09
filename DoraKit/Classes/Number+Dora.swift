//
//  Number+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/7.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation


public extension Int {
    static func dora_parse(_ anyObj:Any?) -> Int {
        var result:Int = 0
        if anyObj is NSNumber {
            result = (anyObj as! NSNumber).intValue
        }
        else if anyObj is String {
            result = Int(anyObj as! String)!
        }
        
        return result
    }
}

public extension Double {
    static func dora_parse(_ anyObj:Any?) -> Double {
        var result:Double = 0.0
        if anyObj is NSNumber {
            result = (anyObj as! NSNumber).doubleValue
        }
        else if anyObj is String {
            result = Double(anyObj as! String)!
        }
        
        return result
    }

    
    func dora_decimal() -> String {
        let format = NumberFormatter()
//        format.numberStyle = .decimal
        format.positiveFormat = "###,##0.00"
        
        let string = format.string(from:NSNumber(value:self))
        if string == nil{
            return "0.00"
        }else{
            return string!
        }
        
    }
}
