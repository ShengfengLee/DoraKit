//
//  LSFMediaPhoto.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation
import Photos

class LSFMediaPhoto {
    public var image: UIImage
    public var asset: PHAsset?
    public let exifMeta : [String : Any]?
    
    public init(image: UIImage, asset: PHAsset? = nil, exifMeta : [String : Any]? = nil) {
        self.image = image
        self.asset = asset
        self.exifMeta = exifMeta
    }
}
