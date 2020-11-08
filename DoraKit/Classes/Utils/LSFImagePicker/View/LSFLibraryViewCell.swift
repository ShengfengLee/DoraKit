//
//  LSFLibraryViewCell.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit


class LSFLibraryViewCell: UICollectionViewCell {
    
    var assetIdentifier: String!
    let imageView = UIImageView()
    
    let selectIndicator = LSFSelectionIndicatorView(size: 18)
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        addSubview(selectIndicator)
        
        let widthConstraint = NSLayoutConstraint(item: selectIndicator,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 0,
                           constant: 44)
        let heightConstraint = NSLayoutConstraint(item: selectIndicator,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 0,
                           constant: 44)
        let topConstraint = NSLayoutConstraint(item: selectIndicator,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .top,
                           multiplier: 0,
                           constant: 5)
        let trailingConstraint = NSLayoutConstraint(item: selectIndicator,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 0,
                           constant: -5)
        
        selectIndicator.addConstraint(widthConstraint)
        selectIndicator.addConstraint(heightConstraint)
        selectIndicator.addConstraint(topConstraint)
        selectIndicator.addConstraint(trailingConstraint)
    }
    
    
    override var isSelected: Bool {
        didSet { isHighlighted = isSelected }
    }
    
    override var isHighlighted: Bool {
        didSet {
            
        }
    }
}
