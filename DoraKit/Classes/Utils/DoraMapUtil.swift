//
//  DoraMapUtil.swift
//  SheLong
//
//  Created by lishengfeng on 2018/9/11.
//  Copyright © 2018年 lishengfeng. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class DoraMapUtil {
    public typealias MapModel = (name: String, url: String)
    public static func getInstallMapAppWithLocation(name: String,
                                             location: CLLocationCoordinate2D,
                                             backScheme: String,
                                             sourceAppName: String? = nil) -> [MapModel] {
        var appName = UIDevice.dora_appName()
        if sourceAppName != nil {
            appName = sourceAppName!
        }
        
        var maps = [MapModel]()
        
        //百度地图
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
            let url = String(format: "baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02", location.latitude, location.longitude, name)
            maps.append((name: "百度地图", url: url))
        }
        
      
        
        //高德地图
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let url = String(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2", appName, backScheme, location.latitude, location.longitude)
            maps.append((name: "高德地图", url: url))
        }
        
        return maps
    }
    
    public static func openMap(name: String,
                        latitude: Double,
                        longitude: Double,
                        backScheme: String,
                        sourceAppName: String? = nil) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        DoraMapUtil.openMap(name: name, location: location, backScheme: backScheme, sourceAppName: sourceAppName)
    }
    
    public static func openMap(name: String,
                        location: CLLocationCoordinate2D,
                        backScheme: String,
                        sourceAppName: String? = nil) {
        
        let maps = DoraMapUtil.getInstallMapAppWithLocation(name: name, location: location, backScheme: backScheme)
       
        var mapNames = maps.map { (item) -> String in
            return item.name
        }
        mapNames.append("苹果地图")
        dora_alert("打开本机地图导航", style: .actionSheet, actionTitles: mapNames, cancelTitle: "取消") { (title, index) in
            if title == "苹果地图" {
                DoraMapUtil.navAppleMap(location: location)
            }
            else {
                if maps.count > index {
                    let map = maps[index]
                    
                    if let url = URL(string: map.url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    public static func navAppleMap(location: CLLocationCoordinate2D) {
        let toItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary: nil))
        let currentItem = MKMapItem.forCurrentLocation()
        
        let items = [currentItem, toItem]
        MKMapItem.openMaps(with: items, launchOptions: nil)
    }
}
