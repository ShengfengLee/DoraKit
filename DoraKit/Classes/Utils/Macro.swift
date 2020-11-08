//
//  Macro.swift
//  hoonpay
//
//  Created by 安诚 on 2017/12/22.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit


/// 导航栏高度


public func getNavigationHeight(_ controller: UIViewController? = nil) ->CGFloat{
    var vc = controller
    if vc == nil{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        if rootVC is UINavigationController {
            vc = (rootVC as! UINavigationController).visibleViewController
        }
        else if rootVC is UITabBarController {
            vc = (rootVC as! UITabBarController).selectedViewController
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
            }
        }
    }
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    let naviBarHeight = vc?.navigationController?.navigationBar.frame.size.height ?? 0
    let navigationHeight = statusBarHeight + naviBarHeight
    return navigationHeight
}

public func getStatusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}

