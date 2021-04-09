//
//  NSObject+Dora.swift
//  yoyo
//
//  Created by apple on 2019/10/15.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation
public extension NSObject {
    
    ///将两个方法实现替换
    static func dora_swizzleMethod(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        } else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}
