//
//  DoraImagePickerController.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/21.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

public typealias ImagePickerCompletion = (_ picker:UIImagePickerController, _ mediaInfo:[UIImagePickerController.InfoKey: Any]?, _ image:UIImage?) -> Void

@objc
public class DoraImagePickerController : UIImagePickerController {
    

    public static let album = DoraLocalized.string("title.photo.edit.album")
    public static let camera = DoraLocalized.string("str.Camera")
    public static let cancel = DoraLocalized.string("str.Cancel")
    
    
    
    public var completion:ImagePickerCompletion?
    public var quality: CGFloat?
    public var presentController:UIViewController?
    public var completon:ImagePickerCompletion?
    
    public var titles = [String]()
    public var otherComplete: ((String) -> Void)?
    
    
    ///强引用自己，防止被释放
    public var selfReference: DoraImagePickerController?
    
    public class func showActionsheet(controller:UIViewController,
                                quality:CGFloat? = nil,
                                sourceView:UIView? = nil,
                                titles: [String] = [camera, album],
                                allowsEditing: Bool = false,
                                completion:ImagePickerCompletion?,
                                otherComplete: ((String) -> Void)? = nil)  {
        let imagePicker = DoraImagePickerController()
        imagePicker.selfReference = imagePicker
        imagePicker.titles = titles
        imagePicker.otherComplete = otherComplete
        imagePicker.allowsEditing = allowsEditing;
        imagePicker.showActionsheet(controller: controller, completion: completion, quality: quality, sourceView: sourceView)
    }
    
//    @objc
    public func showActionsheet(controller: UIViewController,
                         completion: ImagePickerCompletion?,
                         quality: CGFloat? = nil,
                         sourceView: UIView? = nil) {
        
        completon = completion
        self.quality = quality
        
        presentController = controller
        
        
        let cancel = DoraLocalized.string("str.Cancel")
        dora_alert(style: .actionSheet,
                  viewController: controller,
                  actionTitles: titles,
                  cancelTitle: cancel,
                  destructiveTitle:nil,
                  sourceView: sourceView) {(title, index) in
                    if title == DoraImagePickerController.camera {
                        self.openCamera()
                    }
                        
                    else if title == DoraImagePickerController.album {
                        self.openAlbum()
                    }
                    else {
                        self.otherComplete?(title)
                        self.clear()
                    }
        }
    }
    
    public func clear() {
        presentController = nil
        delegate = nil
        selfReference = nil
        completion = nil
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        selfReference = self
        delegate = self
    }
    
    public func openCamera() {
        if self.isCameraAvailable == false {
            dora_alert("Camera not found")
            return
        }
        
        
        ///相机权限
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .denied || authStatus == .restricted {
            
            let ok = DoraLocalized.string("authorization.goSettings")
            let cancel = DoraLocalized.string("str.Cancel")
            let title = DoraLocalized.string("authorization.tips.UnableAccess")
            dora_alert(title, cancelTitle: cancel, destructiveTitle: ok) { (title, _) in
                if title == ok {
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
            
            return
        }
        
        
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.sourceType = .camera
                if strongSelf.isFrontCameraAvailable {
                    strongSelf.cameraDevice = .rear
                }
                strongSelf.presentController?.present(strongSelf, animated: true, completion: nil)
            }
        }
    }
    
    ///打开相册
    public func openAlbum() {
        if !isPhotoLibraryAvailable {
            dora_alert("Error access album")
        }
        
        
        PHPhotoLibrary.requestAuthorization { [weak self]  status in
            if status == .denied || status == .restricted {
                DispatchQueue.main.async {
                    let ok = DoraLocalized.string("authorization.goSettings")
                    let cancel = DoraLocalized.string("str.Cancel")
                    let title = DoraLocalized.string("authorization.tips.UnableAccess")
                    dora_alert(title, cancelTitle: cancel, destructiveTitle: ok) { (title, _) in
                        if title == ok {
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
                }
                
            }
            
            else if status == .authorized {
                
                DispatchQueue.main.async { [weak self] in

                    if let strongSelf = self {
                        strongSelf.sourceType = .photoLibrary
                        strongSelf.presentController?.present(strongSelf, animated: true, completion: nil)
                    }
                    
                }
        
            }
        }
        
    }
    
}

extension DoraImagePickerController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image:UIImage?
        if self.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        }
        else {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }

        //有些情况，上面方式取不到图片
        if image == nil {
            var asset: PHAsset?
            if #available(iOS 11.0, *) {
                asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
            }
                //通过URL获取图片
            else if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let results = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
                asset = results.firstObject
            }

            //PHAsset，通过Asset方式获取图片
            DoraImagePickerController.fetchImage(for: asset) { (img, info) in
                image = img
                picker.dismiss(animated: true) {
                    self.clear()
                    self.completon?(self, nil, image)
                }
            }
            return
        }


        image = image?.dora_fixOrientation() //相机拍出的照片方向有问题，需要修正下

        //压缩质量
        if let quality = self.quality {
            let data = image?.jpegData(compressionQuality: quality)
            if data != nil {
                image = UIImage(data: data!) //转成image
            }
        }
        
        picker.dismiss(animated: true) {
            self.clear()
            self.completon?(self, info, image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.clear()
        }
    }
}

public extension DoraImagePickerController {
    
    ///相机权限
    func cameraPermissions() -> Bool {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    ///相机权限
    func photoPermissions() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .denied || authStatus == .restricted {
            return false
        }
        return true
    }
    
    
    
    ///设备是否支持相机
    var isCameraAvailable:Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    ///设备是否支持 后置摄像头
    var isRearCameraAvailable: Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    ///前置摄像头
    var isFrontCameraAvailable : Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    var isPhotoLibraryAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    
    
    func cameraSupportsMesia(_ mediaType:String, sourceType:UIImagePickerController.SourceType) -> Bool{
        if mediaType.count == 0 {
            return false
        }
        
        guard let types = UIImagePickerController.availableMediaTypes(for: sourceType) else {
            return false
        }
        
        for type in types {
            if type == mediaType {
                return true
            }
        }
        
        return false
    }
}

public extension DoraImagePickerController {
    ///根据Asset来获取图片
    class func fetchImage(for asset: PHAsset?, complete: ((UIImage?, [AnyHashable: Any]?) -> Void)?) {
        guard let asset = asset else {
            complete?(nil, nil)
            return
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true   //允许通过网络从iCloud上拉取
        options.resizeMode = .exact
        options.isSynchronous = true // Ok since we're already in a background thread

        let manager = PHImageManager.default()
        manager.requestImageData(for: asset, options: options) { (data, UTI, imageOrientation, info) in
            guard let data = data else {
                complete?(nil, nil)
                return
            }

            if let image = UIImage(data: data)?.dora_fixOrientation() {
                let exifs = self.metadataForImageData(data: data)
                complete?(image, exifs)
            }
            else {
                complete?(nil, nil)
                return
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
}
