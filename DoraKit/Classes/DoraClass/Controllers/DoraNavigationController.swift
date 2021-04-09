//
//  DoraNavigationController.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/1.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit

class DoraNavigationController: UINavigationController {
    
    var popRecognizer: UIGestureRecognizer!
    
    deinit {
        dprint("deinit DoraNavigationController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = self.interactivePopGestureRecognizer as? UIScreenEdgePanGestureRecognizer
        gesture?.delegate = self
        self.popRecognizer = gesture

        
        //JalonG强烈要求去掉全屏侧滑
        /*
        //禁用系统原生的侧滑返回功能
        gesture?.isEnabled = false
        
        let targets = gesture?.value(forKey: "_targets") as? [NSObject]
        let targetObj = targets?.first
        
        let target = targetObj?.value(forKey: "_target")
        let action = Selector(("handleNavigationTransition:"))
        
        let popRecognizer = UIPanGestureRecognizer.init(target: target,
                                                action: action)
        popRecognizer.delegate = self
        popRecognizer.maximumNumberOfTouches = 1
        
        let gestureView = gesture?.view
        gestureView?.addGestureRecognizer(popRecognizer)
        self.popRecognizer = popRecognizer
        // */
       
    }

   
    
}


extension DoraNavigationController:UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != popRecognizer {
            return true
        }
      
        //根页面
        if self.viewControllers.count < 2 {
            return false
        }
        
        /*
        //从右往左滑
        if gestureRecognizer is UIPanGestureRecognizer {
            let panGest = gestureRecognizer as! UIPanGestureRecognizer
            let translation = panGest.translation(in: panGest.view)
            
            //阿语布局
            if YLLanguage.shared.isFromRightToLeft() {
                if translation.x >= 0  {
                    return false
                }
            }
            else {
                if translation.x <= 0  {
                    return false
                }
            }
        }
        // */
    
    return true
    }
}

