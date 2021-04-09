//
//  UIAlertController+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/7.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit

public func dora_alert(_ title:String? = nil,
               message:String? = nil,
               style:UIAlertController.Style = .alert,
               viewController:UIViewController? = nil,
               actionTitles:[String]? = nil,
               cancelTitle:String? = nil,
               destructiveTitle:String? = nil,
               sourceView:UIView? = nil,
               handle:( (_ title:String, _ index: Int) -> Void )? = nil ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    
    
    //Action
    if let actions = actionTitles {
        for (index, action) in actions.enumerated() {
            let alertAction = UIAlertAction(title: action, style: .default, handler: { (alertAction) in
                handle?(action, index)
            })
            alertController.addAction(alertAction)
        }
    }
    
    var destructive:String?
    if destructiveTitle != nil {
        destructive = destructiveTitle
    }
    else if cancelTitle == nil && actionTitles == nil {
        destructive = "确认"
    }
    
    var indexCount = actionTitles?.count ?? 0
    // 确认按钮
    if let str = destructive {
        let destructiveAction = UIAlertAction.init(title: str, style: .destructive, handler: { (alertAction) in
            
            handle?(str, indexCount)
        })
        alertController.addAction(destructiveAction)
        indexCount += 1
    }
    
    //取消按钮
    if let cancel = cancelTitle {
        let cancelAction = UIAlertAction.init(title: cancel, style: .cancel, handler: { (alertAction) in
            handle?(cancel, indexCount)
        })
        alertController.addAction(cancelAction)
    }
    
    
   
    
    var vc = viewController
    if viewController == nil {
        vc = UIViewController.dora_currentVC()
    }
    
    if  style == .actionSheet {
        let popOverController = alertController.popoverPresentationController
        
        if let view = sourceView {
            popOverController?.sourceView = view
            popOverController?.sourceRect = view.bounds
        }
        else {
            
            popOverController?.sourceView = vc?.view
            var rect = vc!.view.bounds
            rect.size.height -= 300
            popOverController?.sourceRect = rect
        }
    }
    
    vc?.modalPresentationStyle = .popover
//    ///强制设为白色模式，不然一些地方，没有显示指定颜色的view，会变成黑色
//    if #available(iOS 13.0, *) {
//        vc?.view.overrideUserInterfaceStyle = .light
//    } else {
//        // Fallback on earlier versions
//    }
    vc?.present(alertController, animated: true, completion: nil)
}

///显示带输入框的提示框
public func dora_showTextFieldAlert(title: String? = nil,
                            text: String? = nil,
                            placeholder: String?,
                            presentController: UIViewController,
                            complete: ( (String?) -> Void)?) {
    let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
    alertVC.addTextField { (tf) in
        tf.placeholder = placeholder
        tf.text = text
    }
    
    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
    let okAction = UIAlertAction.init(title: "确认", style: .default) { (action) in
        guard  let textField = alertVC.textFields?.first else {  return }
        let str = textField.text
        complete?(str)
    }
    alertVC.addAction(cancelAction)
    alertVC.addAction(okAction)
    presentController.present(alertVC, animated: true, completion: nil)
}

