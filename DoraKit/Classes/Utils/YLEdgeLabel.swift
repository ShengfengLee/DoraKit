//
//  YLEdgeLabel.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/2/21.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation

///带有内边距的Label
public class YLEdgeLabel: UILabel {
    
//    @IBInspectable var insets = UIEdgeInsets.zero
    
    @IBInspectable var insetsLeft: CGFloat = 0
    @IBInspectable var insetsRight: CGFloat = 0
    @IBInspectable var insetsTop: CGFloat = 0
    @IBInspectable var insetsBottom: CGFloat = 0
    
    public var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetsTop, left: insetsLeft, bottom: insetsBottom, right: insetsRight)
    }
    
    public override func drawText(in rect: CGRect) {
        
        let insetRect = rect.inset(by: insets)
        super.drawText(in: insetRect)
    }
}
