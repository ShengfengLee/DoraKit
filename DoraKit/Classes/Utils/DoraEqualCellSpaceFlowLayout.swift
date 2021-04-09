//
//  DoraEqualCellSpaceFlowLayout.swift
//  In9ni
//
//  Created by 李胜锋 on 2018/1/17.
//  Copyright © 2018年 maderia. All rights reserved.
//

import UIKit

public class DoraEqualCellSpaceFlowLayout: UICollectionViewFlowLayout {
    public enum AlignType:Int {
        case left = 0
        case center = 1
        case right = 2
    }
    public var cellSpacing: CGFloat {
        didSet {
            self.minimumInteritemSpacing = cellSpacing
        }
    }
    
    public var alignType = AlignType.center
    
    //在剧中对其的时候需要知道这行所有cell的宽度综合
    public var sumCellWidth :CGFloat = 0
    
    public override init() {
        cellSpacing = 5
        
        super.init()
        
    }
    
    public convenience init(alignType:AlignType, cellSpacing:CGFloat = 5) {
        
        self.init()
        
        self.alignType = alignType
        self.cellSpacing = cellSpacing
    }
    
    public required init?(coder aDecoder: NSCoder) {
        cellSpacing = 5
        super.init(coder: aDecoder)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes_super : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems:true)as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count{
            
            let currentAttr = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index-1]
            let nextAttr = index + 1 == layoutAttributes.count ?
                nil : layoutAttributes[index+1]
            
            layoutAttributes_t.append(currentAttr)
            sumCellWidth += currentAttr.frame.size.width
            
            let previousY :CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY :CGFloat = currentAttr.frame.maxY
            let nextY:CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY && currentY != nextY{
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader{
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }else if currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter{
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }else{
                    self.setCellFrame(with: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }
            }else if currentY != nextY{
                self.setCellFrame(with: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                sumCellWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.layoutAttributesForItem(at: indexPath)
        
        return layoutAttr
    }
    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    func setCellFrame(with layoutAttributes : [UICollectionViewLayoutAttributes]){
        var nowWidth : CGFloat = 0.0
        switch alignType {
        case .left:
            nowWidth = self.sectionInset.left
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.cellSpacing
            }
            break
            
        case .center:
            nowWidth = (self.collectionView!.frame.size.width - sumCellWidth - (CGFloat(layoutAttributes.count - 1) * cellSpacing)) / 2
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.cellSpacing
            }
            break;
        case .right:
            nowWidth = self.collectionView!.frame.size.width - self.sectionInset.right
            for var index in 0 ..< layoutAttributes.count{
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = nowFrame
                nowWidth = nowWidth - nowFrame.size.width - cellSpacing
            }
            break;
        }
    }
    
}
