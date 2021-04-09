//
//  UINavigationController+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/23.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationController {
    
    ///动画方向
    func dora_animate(type: CATransitionType, subType: CATransitionSubtype) {
        let animation = CATransition.init()
        animation.duration = 0.3
        animation.type = type
        animation.subtype = subType
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        self.view.layer.add(animation, forKey: nil)
    }
    
    
    
    func dora_pushController_moveIn_FromTop(_ viewController: UIViewController) {
        self.dora_animate(type: CATransitionType.moveIn, subType: CATransitionSubtype.fromTop)
        self.pushViewController(viewController, animated: false)
    }
    
    func dora_popController_reveal_fromeBottom() {
        
        self.dora_animate(type: CATransitionType.reveal, subType: CATransitionSubtype.fromBottom)
        self.popViewController(animated: false)
    }
    
    
    ///获取导航Bar的背景View
    func dora_navigationBarBackgroundView() -> UIView? {
        guard let backView = navigationBar.value(forKey: "backgroundView") as? UIView else {
            return nil
        }
        return backView
    }
    
    func dora_getNaviBarBackViewFrame() -> CGRect {
        guard let backView = dora_navigationBarBackgroundView() else {
            return CGRect.zero
        }
        let rect = backView.superview?.convert(backView.frame, to: self.view)
        return rect ?? CGRect.zero
    }
    
    ///退出当前页面，进入新的页面，无需动画
    func dora_popCurrentAndPushTp(_ viewController: UIViewController) {
        var tempVCs = self.viewControllers
        tempVCs.removeLast() //移除当前视图
        tempVCs.append(viewController) //增加
        self.setViewControllers(tempVCs, animated: false)
        
    }
}

public extension UINavigationController {
    
    ///设置导航栏
    func dora_set(backgroundColor: UIColor = UIColor.white,
                 shadowColor: UIColor = UIColor.dora_color16(0xe6e6e6),
                 titleColor: UIColor = UIColor.black,
                 titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18),
                 isTranslucent: Bool = false,
                 navigationBar: UINavigationBar? = nil) {
        let naviBar = navigationBar ?? self.navigationBar
        naviBar.setBackgroundImage(UIImage.dora_image(color: backgroundColor), for: .default)
        naviBar.shadowImage = UIImage.dora_image(color: shadowColor)
        naviBar.isTranslucent = isTranslucent
        
        naviBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor,
                                             NSAttributedString.Key.font: titleFont]
    }
}
