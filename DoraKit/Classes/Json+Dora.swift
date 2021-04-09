//
//  Json+Dora.swift
//  yoyo
//
//  Created by 李胜锋 on 2018/11/28.
//  Copyright © 2018 Yalla. All rights reserved.
//

import Foundation


public extension String {
    ///Json转对象
    func dora_jsonToObject() -> Any? {

        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return object
    }
}

extension Data {
    ///Json转对象
    func dora_jsonToObject() -> Any? {
        let object = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return object
    }
}
