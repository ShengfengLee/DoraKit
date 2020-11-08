//
//  File.swift
//  Exam-iOS
//
//  Created by lishengfeng on 2018/4/15.
//  Copyright © 2018年 李胜锋. All rights reserved.
//

import Foundation
import UIKit


public extension UILabel {

    ///显示html文本
    func lsf_htmlText(text: String?) {
        guard let text = text else {
            self.attributedText = nil
            return
        }
        
        self.attributedText = text.lsf_htmlAttributedString(font: self.font)
    }
    
    ///以段落格式显示HTML文本
    func lsf_htmlParagraphText(text: String?,
                               firstLineHeadIndent: CGFloat = 0,
                               paragraphSpacing: CGFloat = 5,
                               lineSpacing: CGFloat = 5) {
        guard let text = text else {
            self.attributedText = nil
            return
        }
        
        self.attributedText = text.lsf_htmlParagraphText(font: self.font,
                                                         firstLineHeadIndent: firstLineHeadIndent,
                                                         paragraphSpacing: paragraphSpacing,
                                                         lineSpacing: lineSpacing)
        
    }
    
    
    ///以段落格式显示HTML文本，并且自适应图片大小
    func lsf_htmlParagraphTextAndFitSize(text: String?,
                                         width: CGFloat,
                                         padding_left: CGFloat = 0,
                                         firstLineHeadIndent: CGFloat = 0,
                                         paragraphSpacing: CGFloat = 5,
                                         lineSpacing: CGFloat = 5) {
        guard let str = text else {
            self.attributedText = nil
            return
        }
        
        ///图片大小自适应
        let html = str.lsf_htmlFitImageSize(width: width)
        
        self.lsf_htmlParagraphText(text: html,
                                   firstLineHeadIndent: firstLineHeadIndent,
                                   paragraphSpacing: paragraphSpacing,
                                   lineSpacing: lineSpacing)
        
    }
}
