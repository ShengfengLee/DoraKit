//
//  UITabBarController+Dora.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/3/25.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation

public extension UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if let vc = selectedViewController {
            return vc.preferredStatusBarStyle
        }
        return UIApplication.shared.statusBarStyle
    }
    
    override var shouldAutorotate: Bool {
        if let vc = selectedViewController {
            return vc.shouldAutorotate
        }
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let vc = selectedViewController {
            return vc.supportedInterfaceOrientations
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        if let vc = selectedViewController {
            return vc.preferredInterfaceOrientationForPresentation
        }
        return UIInterfaceOrientation.portrait
    }
    
    override var childForStatusBarStyle: UIViewController? {
        
        return selectedViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return selectedViewController
    }
}
