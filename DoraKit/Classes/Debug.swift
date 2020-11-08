//
//  Debug.swift
//  Pods
//
//  Created by lishengfeng on 2020/11/8.
//

import Foundation

public func printDebug<T>(_ message: T) {
    #if DEBUG
    print(message)
    #endif
}

public func dprint<T>(_ message: T,
               filePath: String = #file,
               method: String = #function,
               rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    let date = Date().lsf_formate("MM/dd HH:mm:ss")
    print(fileName + ":" + method + "/" + "\(rowCount)" + "[" + date + "]" + " \(message)" + "\n")
    #endif
}


public func dprint(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print(fileName + "/" + "\(rowCount)" + "\n")
    #endif
}

