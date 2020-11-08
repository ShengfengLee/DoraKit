//
//  BarButtonItemable.swift
//  DoraKit
//
//  Created by lishengfeng on 2020/11/8.
//

import Foundation
import RxSwift
import NSObject_Rx
import RxCocoa


///导航栏返回按钮
public protocol BarButtonItemable { }

public extension BarButtonItemable where Self: UIViewController {
    //导航栏按钮
    func getBarButtonItem(_ title: String? = nil,
                                 imageNamed: String? = nil,
                                 tintColor: UIColor? = UIColor.lsf_color16(0x999999),
                                 block: VoidBlock? = nil) -> UIBarButtonItem {
        let barItem = UIBarButtonItem.init()
        
        //图片
        var image: UIImage?
        if let named = imageNamed {
            image = UIImage(named: named)
        }
        
        if let colot = tintColor {
            barItem.tintColor = colot
        }
        else {
            //显示原图
            image = image?.withRenderingMode(.alwaysOriginal)
        }
        barItem.image = image
        
        if let title = title {
            barItem.title = title
        }
        barItem.style = .plain
        
        barItem.rx.tap.bind { [weak self] in
            guard let strongSelf = self else { return }
            if block != nil {
                block?()
            }
            else {
                strongSelf.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: rx.disposeBag)
        
        return barItem
    }
}

public extension BarButtonItemable where Self: UIViewController {
    ///返回按钮
    func setLeftItem(title: String? = nil,
                     imageNamed: String? = "btn_back_gray",
                     tintColor: UIColor? = nil,
                     navigationItem: UINavigationItem? = nil,
                     block: VoidBlock? = nil) {
        let item = getBarButtonItem(title,
                                    imageNamed: imageNamed,
                                    tintColor: tintColor,
                                    block: block)
        
        let naviItem  = navigationItem ?? self.navigationItem
        naviItem.leftBarButtonItem = item
    }
    
    ///右键
    func setRightItem(title: String? = nil,
                      imageNamed: String? = nil,
                      tintColor: UIColor? = nil,
                      navigationItem: UINavigationItem? = nil,
                      block: VoidBlock? = nil) {
        let item = getBarButtonItem(title,
                                    imageNamed: imageNamed,
                                    tintColor: tintColor,
                                    block: block)
        
        let naviItem  = navigationItem ?? self.navigationItem
        naviItem.rightBarButtonItem = item
    }
}

