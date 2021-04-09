//
//  UIDevice+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/3.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import UIKit
import CoreTelephony

public extension UIDevice {

    /// 获取build版本号
    static func dora_bulidVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    
    /// 获取App版本号
    static func dora_version() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /// 获取App名称
    static func dora_appName() -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    /// bundle id
    static func dora_identifier() -> String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    
    /// 获取屏幕的宽度
    static func dora_width() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    
    /// 获取屏幕的高度
    static func dora_height() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    ///获取系统版本
    static func dora_iOS_version() -> Float {
        let version = UIDevice.current.systemVersion
        let v_float = Float(version)
        return v_float!
    }
    
    
    ///判断系统版本是否大于 iOS 7
    static func dora_iOS7_or_later() -> Bool {
        if dora_iOS_version() >= 7.0 {
            return true
        }
        return false
    }
    
    
    ///判断系统版本是否大于 iOS 8
    static func dora_iOS8_or_later() -> Bool {
        if dora_iOS_version() >= 8.0 {
            return true
        }
        return false
    }
    
    
    ///判断系统版本是否大于 iOS 9
    static func dora_iOS9_or_later() -> Bool {
        if dora_iOS_version() >= 9.0 {
            return true
        }
        return false
    }
    
    ///判断系统版本是否大于 iOS 10
    static func dora_iOS10_or_later() -> Bool {
        if dora_iOS_version() >= 10.0 {
            return true
        }
        return false
    }
    
    ///判断是否是iPhone
    static func dora_isPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        }
        return false
    }
    
    ///判断是否是iPhone
    static func dora_isPhone() -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return true
        }
        return false
    }
    
    ///获取机型
    static func dora_model() -> String {
        return UIDevice.current.model
    }
    
    
    static func dora_change(orientation: UIInterfaceOrientation) {
        let device = UIDevice.current
        let number = NSNumber(value: orientation.rawValue)
        device.setValue(number, forKey: "orientation")
    }

    ///获取运营商名字
    static func dora_carrierName() -> String? {
        let info = CTTelephonyNetworkInfo()
        guard let carrier = info.subscriberCellularProvider else { return nil }

        return carrier.carrierName
    }

    ///获取网络类型
    static func dora_networkType() -> String? {

        let info = CTTelephonyNetworkInfo()
        guard let currentRadioTech = info.currentRadioAccessTechnology else { return nil }

        var networkType: String?
        switch currentRadioTech {
        case CTRadioAccessTechnologyGPRS:
            networkType = "2G"
        case CTRadioAccessTechnologyEdge:
            networkType = "2G"
        case CTRadioAccessTechnologyeHRPD:
            networkType = "3G"
        case CTRadioAccessTechnologyHSDPA:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMA1x:
            networkType = "2G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        case CTRadioAccessTechnologyCDMAEVDORev0:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMAEVDORevA:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMAEVDORevB:
            networkType = "3G"
        case CTRadioAccessTechnologyHSUPA:
            networkType = "3G"
        default:
            break
        }
        return networkType
    }
}
