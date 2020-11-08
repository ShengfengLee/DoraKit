//
// LSFImagePicker.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit
import Photos

class LSFImagePicker: LSFNavigationController, BarButtonItemable {
    
    var didFinishPicking: (([LSFMediaPhoto]) -> Void)?
    
    public class func show(controller: UIViewController,
                           maxSelectNumber: Int = 9,
                           didFinishPicking: (([LSFMediaPhoto]) -> Void)?)  {
        
        //判断相册权限
        let photoAuthorize = AuthorizationManager.authorizedPhoto()
        if photoAuthorize == .authorized {
            showPicker(controller: controller, maxSelectNumber: maxSelectNumber, didFinishPicking: didFinishPicking)
        }
        else if photoAuthorize == .notDetermined {
            PHPhotoLibrary.requestAuthorization{ [weak controller]  (status) -> Void in
                if status == .authorized, let strongVc = controller {
                    showPicker(controller: strongVc, maxSelectNumber: maxSelectNumber, didFinishPicking: didFinishPicking)
                }
            }
        }else {
            AuthorizationManager.showPhotoCameraUnAuthorizedAlert()
        }
    }
    
    private class func showPicker(controller: UIViewController,
                                  maxSelectNumber: Int = 9,
                                  didFinishPicking: (([LSFMediaPhoto]) -> Void)?)  {
        DispatchQueue.main.async { //套主线程，不然授权万之后崩溃
            let imagePicker = LSFImagePicker()
            imagePicker.manager.maxSelectNumber = maxSelectNumber
            imagePicker.didFinishPicking = didFinishPicking
            controller.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    let manager = LSFLibraryManager()
    var cameraController: LSFImagePickerController?
    
    
    deinit {
        dprint("deinit LSFImagePicker")
        manager.imageManager?.stopCachingImagesForAllAssets()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let libraryVC = LSFLibraryViewController(manager)
        libraryVC.backHandle = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        libraryVC.completeHandle = { [weak self] items in
            self?.finishPicking()
        }
        
        libraryVC.cameraHandle = { [weak self] in
            self?.openCamera()
        }
        
        libraryVC.selectHandle = { [weak self] index in
            self?.showPreviewPhoto(index)
        }
        viewControllers = [libraryVC]
    }
    
    func showPreviewPhoto(_ index: Int) {
        let previewVC = LSFPreviewPhotoViewController(manager)
        previewVC.index = index
        previewVC.backHandle = { [weak self] in
            self?.popViewController(animated: false)
        }
        
        previewVC.completeHandle = { [weak self] items in
            self?.finishPicking()
        }
        
        pushViewController(previewVC, animated: false)
    }
    
    func finishPicking() {
        manager.selectedMedias { [weak self] (photos) in
            self?.didFinishPicking?(photos)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        cameraController = LSFImagePickerController()
        cameraController?.presentController = self
        cameraController?.completon = { [weak self] (picker, info, aImage) in
            
             //相机拍出的照片方向有问题，需要修正下
            
            if let data = aImage?.pngData(), let image = aImage?.lsf_fixOrientation() {
                let exifs = LSFLibraryManager.metadataForImageData(data: data)
                let photo = LSFMediaPhoto(image: image, asset: nil, exifMeta: exifs)
                self?.didFinishPicking?([photo])
                self?.dismiss(animated: true, completion: nil)
            }
        }
        cameraController?.openCamera()
    }
}
