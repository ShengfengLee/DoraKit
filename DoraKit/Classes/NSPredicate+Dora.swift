//
//  Predicate+Dora.swift
//  Exam-iOS
//
//  Created by 李胜锋 on 2018/3/19.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation


public extension NSPredicate {
    ///只能是数字
    static func dora_onlyNumber(_ string: String?) -> Bool {
        let format = "[0-9]*"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", format)
        let result = predicate.evaluate(with: string)
        return result
    }
    
    ///只能是中文
    static func dora_onlyChinese(_ string: String?) -> Bool {
        let format = "[\u{4e00}-\u{9fa5}]+"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", format)
        let result = predicate.evaluate(with: string)
        return result
    }
}
