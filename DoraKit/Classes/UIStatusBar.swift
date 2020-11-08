//
//  UIStatusBar.swift
//  Exam-iOS
//
//  Created by 李胜锋 on 2018/3/20.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation

///获取状态栏
public func getStatusBar() -> UIView? {
    guard let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView
        else
    { return nil
        
    }
    guard let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView
        else {
            return nil
    }
    return statusBar
}
