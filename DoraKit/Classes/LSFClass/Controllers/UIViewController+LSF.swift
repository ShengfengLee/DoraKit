//
//  UIViewController+LSF.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/8.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit


protocol StoryboardProtol { }
extension StoryboardProtol where Self: UIViewController {
    static func lsf_storyboardContrller(_ storyboardName: String, identifier: String? = nil) -> Self {
        
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        
        var id = identifier
        if id == nil {
            let type = NSStringFromClass(self.classForCoder())
            id = type.components(separatedBy: ".").last
        }
        return storyboard.instantiateViewController(withIdentifier: id!) as! Self
    }
}

extension UIViewController: StoryboardProtol {}

extension UIViewController{
    
    ///获取当前显示的VC
    public static func lsf_currentVC() -> UIViewController? {
        var result: UIViewController?
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    window = tmpWin
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponse = frontView?.next
        if nextResponse is UIViewController {
            result = nextResponse as? UIViewController
        }
        else {
            result = window?.rootViewController
        }
        
        if result is UITabBarController {
            let tabbarVC = result as! UITabBarController
            result = tabbarVC.selectedViewController
        }
        
        if result is UINavigationController {
            let naviVC = result as! UINavigationController
            result = naviVC.visibleViewController
        }
        return result
    }
    
    //判断当前ViewController是否正在显示
    var lsf_isVisible: Bool {
        if self.isViewLoaded, self.view.window != nil {
            return true
        }
        return false
    }
}
