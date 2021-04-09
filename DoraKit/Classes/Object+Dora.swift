//
//  Object+Dora.swift
//  Exam-iOS
//
//  Created by 李胜锋 on 2018/3/14.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation

public typealias VoidBlock = () -> Void
public typealias StringBlock = (String) -> Void
public typealias IntBlock = (Int) -> Void
public typealias BoolBlock = (Bool) -> Void

public func sync(lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

///对象转Json字符串
public func dora_toJson(_ object: Any?) -> String? {
    guard let object = object else {
        return nil
    }
    
    if JSONSerialization.isValidJSONObject(object) == false {
        return nil
    }
    
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    let jsonString = String.init(data: data, encoding: String.Encoding.utf8)
    return jsonString
}

///对象转Json字符串
public func dora_toJsonData(_ object: Any?) -> Data? {
    guard let object = object else {
        return nil
    }
    
    if JSONSerialization.isValidJSONObject(object) == false {
        return nil
    }
    
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return data
}


///Json转对象
public func dora_jsonToObject(_ obj: Any?) -> Any? {
    var data = obj as? Data
    
    if let string = obj as? String {
        data = string.data(using: String.Encoding.utf8)
    }
    
    if let data = data {
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return object
    }
    return nil
    
}
