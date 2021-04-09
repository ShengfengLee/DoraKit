//
//  Array+Dora.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/5/8.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation

public extension Array {
    
    
    /// 数组去重
    ///
    /// - Parameter filter: 去重条件
    /// - Returns: 去重后的数组
    func dora_filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for item in self {
            let key = filter(item)
            let filterArray = result.map { filter($0) }
            let contains = filterArray.contains(key)
            if contains == false {
                result.append(item)
            }
        }
        
        return result
    }
}
