//
//  LSFLibraryManager.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation
import Photos

class LSFLibraryManager: NSObject {
    
    var imageManager: PHCachingImageManager?
    var fetchResult: PHFetchResult<PHAsset>?
    
    var selection = [ImagePickerSelection]()
    var maxSelectNumber = 9
    var isLimitSelect: Bool {
        return selection.count >= maxSelectNumber
    }
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    func fetchRequest() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: options)
        imageManager = PHCachingImageManager()
    }
    
    
    func selectedMedias(photCallback: ((_ photos: [LSFMediaPhoto])->Void)?) {
        let selectAssets: [PHAsset] = selection.map {
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [$0.assetIdentifier], options: PHFetchOptions())
            guard let asset = assets.firstObject else { fatalError() }
            return asset
        }
        
        var resultPhotos = [LSFMediaPhoto]()
        let group = DispatchGroup()
        for asset in selectAssets {
            group.enter()
            fetchImage(for: asset) { (image, exifs) in
                if let image = image {
                    let photo = LSFMediaPhoto(image: image, asset: asset, exifMeta: exifs)
                    resultPhotos.append(photo)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            photCallback?(resultPhotos)
        }
        
    }
    
    //获取图片，以及图片信息
    func fetchImage(for asset: PHAsset, complete: ((UIImage?, [String: Any]?) -> Void)?) {
        let options = photoImageRequestOptions()
        imageManager?.requestImageData(for: asset, options: options) { (data, UTI, imageOrientation, info) in
            if let data = data,
                let image = UIImage(data: data)?.lsf_fixOrientation() {
                let exifs = LSFLibraryManager.metadataForImageData(data: data)
                complete?(image, exifs)
            }
            else {
                complete?(nil, nil)
            }
        }
    }
    
    class func metadataForImageData(data: Data) -> [String: Any]? {
        if let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil),
            let metaData = imageProperties as? [String : Any] {
            return metaData
        }
        return [:]
    }
    
    private func photoImageRequestOptions() -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.isSynchronous = true // Ok since we're already in a background thread
        return options
    }
}

extension LSFLibraryManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}


extension LSFLibraryManager {
    func select(_ assetIdentifier: String,
                complete: ((_ isDelete: Bool)->Void)?) {
        //判断当前indexPath是否被选中
        let cellIsInTheSelectionPool = isInSelectionPool(assetIdentifier)
        
        if cellIsInTheSelectionPool {
            delete(assetIdentifier)
            complete?(true)
        } else if isLimitSelect == false {
            add(assetIdentifier)
            complete?(false)
        }
        else {
//            let tipStr = String(format: LSFLocalized.string("discovier.title.maximumPhotos"), maxSelectNumber)
//            YLPublicClass.showWithMessage(message: tipStr)
        }
    }
    
    func delete(_ assetIdentifier: String) {
        guard let positionIndex = selection.firstIndex(where: { $0.assetIdentifier == assetIdentifier }) else { return }
        selection.remove(at: positionIndex)
    }
    
    /// Adds cell to selection
    func add(_ assetIdentifier: String) {
        let item = ImagePickerSelection(assetIdentifier)
        selection.append(item)
    }
    
    func isInSelectionPool(_ assetIdentifier: String) -> Bool {
        return selection.contains(where: { $0.assetIdentifier == assetIdentifier })
    }
    
}
