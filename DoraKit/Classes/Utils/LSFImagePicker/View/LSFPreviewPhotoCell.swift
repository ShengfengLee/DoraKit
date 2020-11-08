//
//  LSFPreviewPhotoCell.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/10.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit

class LSFPreviewPhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    var assetIdentifier: String!
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ImagePicker_camera")
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func set(_ image: UIImage) {
        imageView.image = image
    }
}
