
//
//  POPable.swift
//  Exam-iOS
//
//  Created by 李胜锋 on 2018/3/1.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation
import UIKit

protocol PopEnable {
    func setPopRecognizerEnable(_ enable: Bool)
    func popRecognizerEnabled() -> Bool
}

extension UIViewController: PopEnable { }

extension PopEnable where Self: UIViewController {
    func setPopRecognizerEnable(_ enable: Bool) {
        if let navigationController = self.navigationController {
            if navigationController is DoraNavigationController {
                (navigationController as! DoraNavigationController).popRecognizer.isEnabled = enable
            }
            else{
                let popRecognizer = navigationController.interactivePopGestureRecognizer
                popRecognizer?.isEnabled = enable
            }
        }
    }
    
    func popRecognizerEnabled() -> Bool {
        if let navigationController = self.navigationController {
            if navigationController is DoraNavigationController {
                return (navigationController as! DoraNavigationController).popRecognizer.isEnabled
            }
            else{
                let popRecognizer = navigationController.interactivePopGestureRecognizer
                return (popRecognizer?.isEnabled)!
            }
        }
        return false
    }

}

extension UIViewController {
    
    public var popGestureRecognizer: UIGestureRecognizer? {
           //设置手势优先级
           var pop: UIGestureRecognizer?
           if let navi = self.navigationController as? DoraNavigationController {
               pop = navi.popRecognizer
           }
           else {
               pop = self.navigationController?.interactivePopGestureRecognizer
           }
           return pop
       }
}

