//
//  AuthorizationManager.swift
//  DoraKit
//
//  Created by lishengfeng on 2020/11/8.
//

import Foundation
import UIKit
import UserNotifications
import Photos


//typealias  = () -> Void

public class AuthorizationManager: NSObject {
    
    
    //MARK:  ------------  麦克风  ------------
    
    
    ///请求麦克风权限
    class func microphoneAuthorization(presentVC: UIViewController? = nil,
                                       authoResultBlock:@escaping (_ isSeccessed: Bool) -> ()) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (allowed) in
            DispatchQueue.main.async {
                authoResultBlock(allowed)
                //没有麦克风权限，弹框
                if allowed == false && status != .notDetermined {
                    if presentVC == nil {
                        self.showMicphoneUnAuthorizedAlert()
                    }
                    else {
                        self.showMicphoneUnAuthorizedAlert(presentVC: presentVC!)
                    }
                }
            }
        }
    }
    
    ///获取麦克风授权状态
    class func microAuthostatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        //return status
        
        var flag = false
        switch status {
        case .notDetermined:
            //没有询问是否开启麦克风
            flag = false
        case .restricted:
            //未授权，家长限制
            flag = false
        case .denied:
            //玩家未授权
            flag = false
        case .authorized:
            //玩家授权
            flag = true
        default:
            flag = false
        }

        return flag
        
    }
    
    
    
    
    
    
    //MARK:  ------------  定位权限  ------------
    
    
    /// 定位权限处理
    ///
    /// - Returns: true有定位权限  false没有定位权限
    class func locationAuthorization(presentVC: UIViewController? = nil) -> Bool {
        let locationStatus = DoraLocationManager.shared.authorizationStatus()
        dprint("位置授权状态: \(locationStatus.rawValue) ...")
        var authorized = false
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            dprint("应用有定位权限...")
            //获取定位数据
            //YLLocationManager.shared.loadLocation()
            DoraLocationManager.shared.startLocation { (location, placemark, error) in
                
            }
            authorized = true
            
        case .notDetermined: //用户尚未对此应用程序做出选择
            //请求定位权限, 获取经纬度 (如果一开始拒绝过定位权限,这里则不会弹出框框.如果没请求过,这里则会弹出框框.如果没请求权限,直接进入设置里,是找不到定位那一项的)
            //YLLocationManager.shared.loadLocation()
            
    //        YLLocationManager.startUpdatingLocation()
            
            DoraLocationManager.shared.startLocation { (location, placemark, error) in
                
            }
            authorized = false
            
        default:
            if presentVC == nil {
                self.showLocationUnAuthorizedAlert() //跳到设置开启定位权限
            }
            else {
                self.showLocationUnAuthorizedAlert(presentVC: presentVC!)
            }
            
            authorized = false
        }
        
        return authorized
    }
    
    
    
    
    
    
    //MARK:  ------------  通知推送  ------------
    
    
    /// 获取通知权限
    class func notificationAuthorization(notificationResultBlock:@escaping (_ isSeccessed: Bool) -> ()) {
        /// 取得用户授权
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert, .carPlay]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
                notificationResultBlock(success)
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        //向APNs请求token
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    
    
    
    
    
    
    
    //MARK:  ------------  相机相册  ------------
    
    
    ///检查相机权限，授权成功回调出去
    class func checkeCameraAuth(authrizedBlock: VoidBlock?, unAuthBlock: VoidBlock?) {
        ///相机权限
        let cameraAuthorize = AuthorizationManager.cameraStatus()
        switch cameraAuthorize {
        case .authorized:
            authrizedBlock?()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {(b) in
                if b == true {
                    authrizedBlock?()
                }else {
                    unAuthBlock?()
                }
            }
        default:
            unAuthBlock?()
            AuthorizationManager.showPhotoCameraUnAuthorizedAlert()
        }
    }
    
    
    ///相机权限
    class func cameraStatus() -> AVAuthorizationStatus {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus
        //return authStatus != .restricted && authStatus != .denied
    }
    
    
    ///相册权限
    class func authorizedPhoto() -> PHAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        return status
        
//        switch status {
//        case .authorized:
//            return true
//        case .notDetermined:  //第一次触发授权
//            // 请求授权
//            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
//                DispatchQueue.main.async(execute: { () -> Void in
//                    _ = self.authorizedPhoto()
//                })
//            })
//
//        default:
//            return false
//        }
//
//        return false
    }
    
    
    ///授权类型
    enum AuthorizedType {
        ///麦克风权限
        case micphone
        ///定位权限
        case location
        ///相册权限
        case album
        ///相机权限
        case camera
    }
    
    
    
    
    
    
}




public extension AuthorizationManager {
    
    ///麦克风未授权，弹框
    class func showMicphoneUnAuthorizedAlert(presentVC: UIViewController? = UIViewController.dora_currentVC()) {
        
        
        showAuthAlertController(title: nil,
                                message: DoraLocalized.string("authorization.goSettingOpenMicroPhoneDesc"),
                                presentController: presentVC)
        
    }
    
    
    ///定位未授权，弹框
    class func showLocationUnAuthorizedAlert(presentVC: UIViewController? = UIViewController.dora_currentVC()) {
        showAuthAlertController(title: nil,
                                message: DoraLocalized.string("authorization.goSettingOpenLocationDesc"),
                                presentController: presentVC)
    }
    
    
    ///相机相册未授权，弹框
    class func showPhotoCameraUnAuthorizedAlert(presentVC: UIViewController? = UIViewController.dora_currentVC()) {
        showAuthAlertController(title: nil,
                                message: DoraLocalized.string("authorization.goSettingOpenAlbumCamera"),
                                presentController: presentVC)
    }
    
    ///网络未授权，弹框
    class func showNetworkingUnAuthorizedAlert(presentVC: UIViewController?) {
        DispatchQueue.main.async {
            let presentVC = presentVC ?? UIViewController.dora_currentVC()
            showAuthAlertController(title: DoraLocalized.string("str.NetworkConnectionFailed"),
                                    message: DoraLocalized.string("authorization.networkingDesc"),
                                    presentController: presentVC)
        }
    }
    
    
    
    ///没有权限时，引导用户去设置页开启权限
    class func showAuthAlertController(title: String?,
                                       message: String?,
                                       presentController: UIViewController?) {
        
        guard let controller = presentController else {
            dprint("⚠️⚠️⚠️获取当前控制器为空⚠️⚠️⚠️")
            return
        }
        
        let goSetting = DoraLocalized.string("authorization.goSettings")
        let cancel = DoraLocalized.string("str.Cancel")
        
        dora_alert(title, message: message, viewController: controller, actionTitles: [goSetting], cancelTitle: cancel) { (title, _) in
            if title == goSetting {
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


