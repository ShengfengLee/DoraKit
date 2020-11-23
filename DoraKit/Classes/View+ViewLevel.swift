//
//  View+ViewLevel.swift
//  ViewLevel-Test
//
//  Created by lishengfeng on 2020/9/27.
//  Copyright © 2020 lishengfeng. All rights reserved.
//

import Foundation
import UIKit
extension UIView {

    //根据指定层级，添加子视图
    func yl_addView(_ subView: UIView, level: Int?) {
        guard let level = level else {
            self.addSubview(subView)
            return
        }
        subView.viewLevelKey = level * 100
        let allSubviews = self.subviews

        var insertIndex: Int = -1
        for (index, item) in allSubviews.enumerated() {
            if item.viewLevelKey <= subView.viewLevelKey {
                if index > insertIndex {
                    insertIndex = index
                }
            }
        }

        self.insertSubview(subView, at: insertIndex + 1)
    }
}

fileprivate extension UIView {
    private struct ViewLevel {
        static var levelKey = "levelKey"
    }

    ///层级
    @objc var viewLevelKey: Int {
        get {
            let number = objc_getAssociatedObject(self, &ViewLevel.levelKey) as? NSNumber
            return number?.intValue ?? 0
        }
        set {
            let number = NSNumber(integerLiteral: newValue)
            objc_setAssociatedObject(self, &ViewLevel.levelKey, number, .OBJC_ASSOCIATION_COPY) }
    }
}
