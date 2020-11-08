//
//  Int+LSF.swift
//  yoyo
//
//  Created by lishengfeng on 2020/5/22.
//  Copyright © 2020 Yalla. All rights reserved.
//

import Foundation
public extension Int {
    //数字转成带，逗号分隔符的字符串
    var lsf_decimalString: String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        if let formatStr = format.string(from: NSNumber(value: self)) {
            return formatStr
        }
        else {
            return"\(self)"
        }
    }
}

public extension Int64 {
    //数字转成带，逗号分隔符的字符串
    var lsf_decimalString: String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        if let formatStr = format.string(from: NSNumber(value: self)) {
            return formatStr
        }
        else {
            return"\(self)"
        }
    }
}
