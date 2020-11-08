//
//  String+LSF.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/7.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    static func lsf_parse(_ anyObj:Any?) -> String? {
        var result:String?
        if anyObj is String {
            result = anyObj as? String
        }
        
        return result
    }
    
    ///判断字符串是否有值
    static func lsf_hasValue(_ string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        if string.count > 0 {
            return true
        }
        return false
    }
    
    ///HTML转化成AttributedString
    func lsf_htmlAttributedString(font: UIFont) -> NSMutableAttributedString? {
        
        guard let data = self.data(using: String.Encoding.unicode, allowLossyConversion: true) else {
            return NSMutableAttributedString.init(string: self)
        }
        
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        do{
            let attri = try NSMutableAttributedString.init(data: data, options: options, documentAttributes: nil)
            return attri
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    ///HTML转化成AttributedString,设置段落格式
    func lsf_htmlParagraphText(font: UIFont,
                               firstLineHeadIndent: CGFloat = 0,
                               paragraphSpacing: CGFloat = 5,
                               lineSpacing: CGFloat = 5)  -> NSMutableAttributedString? {

        let attri = self.lsf_htmlAttributedString(font: font)
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = firstLineHeadIndent
        style.alignment = .left
        //段落间距
        style.paragraphSpacing = paragraphSpacing
        style.lineSpacing = lineSpacing
        let range = NSRange.init(location: 0, length: (attri?.string.count)!)
        attri?.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        
        return attri
    }
    
    func lsf_htmlFitImageSize(width: CGFloat) -> String {
        var html = ""
        html.append("<head><style>")
        html.append("img{width:%g !important;height:auto; padding-left:0;}")
        html.append("</style></head>")
        
        html = String(format: html, width)
        html.append(self)
        return  html
    }
    
    
    
    //Range转换为NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func lsf_labelHeight(width: CGFloat,
                         attributes: [NSAttributedString.Key: Any]?,
                         options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let string = NSString(string: self)
        let size = CGSize(width: width, height: CGFloat.init(MAXFLOAT))
        let rect = string.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    
    func lsf_labelWidth(height: CGFloat,
                         attributes: [NSAttributedString.Key: Any]?,
                         options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let string = NSString(string: self)
        let size = CGSize(width: CGFloat.init(MAXFLOAT), height: height)
        let rect = string.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    
//    /// 获取MD5
//    /// - Parameter upper: 是否返回大写
//    func lsf_md5(upper: Bool = false) -> String {
//        let cStrl = cString(using: String.Encoding.utf8)
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
//        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer)
//        var md5String = ""
//        
//        for idx in 0...15 {
//            var obcStrl: String
//            if upper {
//                //大写
//                obcStrl = String.init(format: "%02X", buffer[idx])
//            }
//            else {
//                //小写
//                obcStrl = String.init(format: "%02x", buffer[idx])
//            }
//            md5String.append(obcStrl)
//        }
//        free(buffer);
//        return md5String;
//    }
}
