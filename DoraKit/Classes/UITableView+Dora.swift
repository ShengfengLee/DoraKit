//
//  UITableView+Dora.swift
//  yoyo
//
//  Created by apple on 2019/9/25.
//  Copyright © 2019 Yalla. All rights reserved.
//

import Foundation

import UIKit

public extension UITableView {

    @discardableResult
    func dora_setSafeFooterView(closure: ((UIView) -> Void)? = nil) -> UIView {
        let footer = UIView()
        footer.backgroundColor = self.backgroundColor
        let height = UIView.dora_safeAreaInsets().bottom
        footer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
        closure?(footer)
        self.tableFooterView = footer
        return footer
    }
}
