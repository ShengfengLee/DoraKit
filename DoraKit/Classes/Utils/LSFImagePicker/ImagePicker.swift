//
//  ImagePicker.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation
import Photos

class ImagePicker {
    ///判断是否授权
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
        PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    ///检查权限
    class func checkPermission(_ complete: ((Bool)->Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            complete?(true)
        case .restricted, .denied:
            let ok = LSFLocalized.string("authorization.goSettings")
            let cancel = LSFLocalized.string("str.Cancel")
            let title = LSFLocalized.string("authorization.tips.UnableAccess")
            lsf_alert(title, cancelTitle: cancel, destructiveTitle: ok) { (title, _) in
                if title == cancel {
                    complete?(false)
                }
                else if title == ok {
                    let settingUrl = UIApplication.openSettingsURLString
                    if let url = URL(string: settingUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (s) in
                DispatchQueue.main.async {
                    complete?(s == .authorized)
                }
            }
        
        @unknown default:
            break
        }
    }
    
   class func fetchImages(_ asset: PHAsset) {
        let imageManager =  PHImageManager()
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            
        }
    }
}
