//
//  LSFEqualSpacingFlowLayout.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/2/22.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit

public class LSFEqualSpacingFlowLayout: UICollectionViewFlowLayout {
    public enum Alignment : Int {
        case left
        case right
    }
    
    var align: Alignment = .right
 
    // 左右对齐等间距布局 (设置了最大间距)
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for (index,value) in (attributes.enumerated()) {
//            let section = value.indexPath.section
            let item = value.indexPath.item
            
            let currentLayoutAttributes = value
            var frame = currentLayoutAttributes.frame
            //左对齐
            if align == .left {
                if item == 0 {
                    frame.origin.x = sectionInset.left
                }
                else {
                    var prevLayoutAttributes: UICollectionViewLayoutAttributes
                    if attributes.count > index - 1 {
                        prevLayoutAttributes = attributes[index - 1]
                    }
                    else {
                        return attributes
                    }
                    let origin = prevLayoutAttributes.frame.maxX
                    if(origin + minimumInteritemSpacing + currentLayoutAttributes.frame.size.width + sectionInset.right <= self.collectionViewContentSize.width) {
                        frame.origin.x = origin + minimumInteritemSpacing
                        frame.origin.y = prevLayoutAttributes.frame.origin.y
                    }
                    else {
                        frame.origin.x = sectionInset.left
                        frame.origin.y = prevLayoutAttributes.frame.maxY + minimumLineSpacing
                    }
                }
            }
                
            //右对齐
            else {
                
                if item == 0 {
                    frame.origin.x = self.collectionViewContentSize.width - frame.size.width - sectionInset.right
                }
                else {
                    var prevLayoutAttributes: UICollectionViewLayoutAttributes
                    if attributes.count > index - 1 {
                        prevLayoutAttributes = attributes[index - 1]
                    }
                    else {
                        return attributes
                    }
                    let origin = prevLayoutAttributes.frame.minX
                    if origin - minimumInteritemSpacing - currentLayoutAttributes.frame.size.width - sectionInset.left >= 0 {
                        frame.origin.x = origin - minimumInteritemSpacing - currentLayoutAttributes.frame.size.width
                        frame.origin.y = prevLayoutAttributes.frame.origin.y
                    }
                    else {
                        frame.origin.x = self.collectionViewContentSize.width - frame.size.width - sectionInset.right
                        frame.origin.y = prevLayoutAttributes.frame.maxY + minimumLineSpacing
                    }
                }
            }
            currentLayoutAttributes.frame = frame;
            
        }
        return attributes
    }
}
