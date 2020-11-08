//
//  LSFLocationManager.swift
//  SheLong
//
//  Created by lishengfeng on 2018/8/3.
//  Copyright © 2018年 lishengfeng. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation

public class LSFLocationManager: NSObject {
    
    public typealias LocationCallBack = (_ curLocation: CLLocation?,_ placemark: CLPlacemark?,_ error: Error?)->()

    public static let shared = LSFLocationManager()
    

    
    public let manager = CLLocationManager()
    
    //当前坐标
    public var curLocation: CLLocation?
    public var placemark: CLPlacemark?
    //当前位置地址
    public var curAddress: String?
    ///获取到定位是否需要获取城市地址
    public var needAddress: Bool = false
    
    
    //回调闭包
    public var callBack: LocationCallBack?
    
    
    public override init() {
        super.init()
        
        //设置定位服务管理器代理
        manager.delegate = self
        //设置定位模式
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        //更新距离
        manager.distanceFilter = 100
        //发送授权申请
        manager.requestWhenInUseAuthorization()
    }
    
    
    public func authorizationStatus() -> CLAuthorizationStatus {
        ///定位权限
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            lsf_alert("需要获取定位权限",
                      message:"请在“[设置]-[隐私]-[定位]”里允许使用",
                      style: .actionSheet,
                      actionTitles: ["去设置"],
                      cancelTitle: "取消",
                      sourceView: nil, handle: { (title, index) in
                if title == "去设置" {
                    let url = URL.init(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.openURL(url!)
                }
            })
        }
        return status
    }
    
    //更新位置
    public func startLocation(needAddress: Bool = false, resultBack: @escaping LocationCallBack){
        
        self.callBack = resultBack
        self.needAddress = needAddress
        
        if CLLocationManager.locationServicesEnabled(){
            //允许使用定位服务的话，开启定位服务更新
            manager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
}


extension LSFLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        curLocation = locations.last!
        //停止定位
        if locations.count > 0{
            manager.stopUpdatingLocation()
            
            if needAddress {
                //经纬度逆编
                reverseLocation()
            }
            else {
                self.callBack!(self.curLocation, nil, nil)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callBack!(nil, nil, error)
    }
    
    ///经纬度逆编
    public func reverseLocation() {
        
        guard let location = self.curLocation else { return }
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if(error == nil){
                let firstPlaceMark = placemark!.first
                
                self.placemark = firstPlaceMark
                self.curAddress = ""
                //省
                if let administrativeArea = firstPlaceMark?.administrativeArea {
                    self.curAddress?.append(administrativeArea)
                }
                //自治区
                if let subAdministrativeArea = firstPlaceMark?.subAdministrativeArea {
                    self.curAddress?.append(subAdministrativeArea)
                }
                //市
                if let locality = firstPlaceMark?.locality {
                    self.curAddress?.append(locality)
                }
                //区
                if let subLocality = firstPlaceMark?.subLocality {
                    self.curAddress?.append(subLocality)
                }
                //地名
                if let name = firstPlaceMark?.name {
                    self.curAddress?.append(name)
                }
                
                self.callBack!(self.curLocation, self.placemark, nil)
                
            }else{
                self.callBack!(self.curLocation, nil, error)
            }
        }
    }
    
}
