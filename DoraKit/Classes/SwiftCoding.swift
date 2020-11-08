//
//  SwiftCoding.swift
//  Exam-iOS
//
//  Created by lishengfeng on 2018/3/10.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation

public extension NSObject {
    func codableProperties() -> [String: Any?] {
        var codableProperites = [String: Any?]()
    
        let mirror = Mirror.init(reflecting: self)
        
        for (label, value) in mirror.children {
            if let name = label {
                codableProperites[name] = unwrap(value)
            }
        }
        
        return codableProperites
    }
    
    func unwrap(_ any: Any) -> Any? {
        let mirror = Mirror.init(reflecting: any)
        if mirror.displayStyle != .optional {
            return any
        }
         // Optional.None
        if mirror.children.count == 0 {
            return nil
        }
        
        let first = mirror.children.first
        return first?.value
    }
   
}
