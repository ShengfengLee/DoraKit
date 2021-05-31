//
//  EdgeInsetsLabel.swift
//  DoraKit
//
//  Created by 李胜锋 on 2021/5/31.
//

import UIKit

///带有边距的label
@objcMembers public class EdgeInsetsLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    ///label的边距
    public var edgeInsets = UIEdgeInsets.zero
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    ///UIView的内置内容大小，常用的UILabel、UIImageView、UIButton不需要设置约束的宽、高
    public override var intrinsicContentSize: CGSize {
        get {
            var size = super.intrinsicContentSize
            size.width = size.width + edgeInsets.left + edgeInsets.right
            size.height = size.height + edgeInsets.top + edgeInsets.bottom
            return size
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.width = size.width + edgeInsets.left + edgeInsets.right
        size.height = size.height + edgeInsets.top + edgeInsets.bottom
        return size
    }

}
