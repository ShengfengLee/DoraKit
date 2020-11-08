//
//  UINavigationController+LSF.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/3/25.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation

public extension UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = topViewController {
            return vc.preferredStatusBarStyle
        }
        return UIApplication.shared.statusBarStyle
    }
    
    override var shouldAutorotate: Bool {
        if let vc = topViewController {
            return vc.shouldAutorotate
        }
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if let vc = topViewController {
            return vc.supportedInterfaceOrientations
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        if let vc = topViewController {
            return vc.preferredInterfaceOrientationForPresentation
        }
        return UIInterfaceOrientation.portrait
    }
    
    override var childForStatusBarStyle: UIViewController? {
        
        return self.topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        
        return self.topViewController
    }
}
