//
//  LSFLocalized.swift
//  iOS_ Template
//
//  Created by lishengfeng on 2020/11/7.
//

import Foundation

public class LSFLocalized {
    public class func string(_ key: String, table: String? = nil, bundlePathName: String? = nil) -> String {
        var bundle: Bundle? = Bundle.main
        if let pathName = bundlePathName,
           let path = Bundle.main.path(forResource: pathName, ofType: "lproj") {
            bundle = Bundle(path: path)
        }
        return bundle?.localizedString(forKey: key, value: nil, table: table) ?? key
    }
}
