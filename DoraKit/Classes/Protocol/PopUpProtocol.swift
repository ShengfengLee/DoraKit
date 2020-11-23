//
//  PopUpProtocol.swift
//  yoyo
//
//  Created by lishengfeng on 2020/4/15.
//  Copyright © 2020 Yalla. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let kTopInset: CGFloat = UIApplication.shared.statusBarFrame.size.height + 50
public enum PopUpContentSheetStyle {
    ///高度自适应
    case auto
    ///默认上边距为kTopInset
    case defaultTopOffset
    ///内容上边距
    case topOffset(CGFloat)
    ///指定内容高度
    case content(CGFloat)
}

/// 弹出页面
public protocol PopUpProtocol {

    ///contentView的底部约束。 该属性必须要实现
    var contentViewBottomConstraint: NSLayoutConstraint! { get }

    ///contentView的高度约束， 可选实现
    var contentHeightConstraint: NSLayoutConstraint? { get }

    ///关闭回调， 可选实现
    var closedHandle: VoidBlock? { get }
    ///默认高度显示方案， 可选实现
    var popUpContentSheetStyle: PopUpContentSheetStyle { get }
}

public extension PopUpProtocol where Self: UIViewController {

    var closedHandle: VoidBlock? {
        return nil
    }

    var popUpContentSheetStyle: PopUpContentSheetStyle {
        return .defaultTopOffset
    }

    var contentHeightConstraint: NSLayoutConstraint? {
        return nil
    }

    /// 显示
    /// - Parameters:
    ///   - controller: 指定父视图
    ///   - level: 在父视图的层级
    func show(in controller: UIViewController, level: Int? = nil) {
        controller.addChild(self)
        if let level = level {
            controller.view.yl_addView(self.view, level: level)
        }
        else {
            controller.view.addSubview(self.view)
        }
        self.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.view.layoutIfNeeded()
        
        //设置约束为显示状态
        updateLayoutToShow()
    }

    ///初始化，需要主动调用
    func setupPopUp() {
        if let constraint = self.contentViewBottomConstraint {
            constraint.constant = 0 - self.view.frame.size.height
        }

        //背景view
        self.view.insertSubview(backView, at: 0)
        self.backView.frame = self.view.bounds
//        backView.snp.makeConstraints({ (maker) in
//            maker.edges.equalToSuperview()
//        })

        //背景点击事件
        let tap = UITapGestureRecognizer()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tap)
        tap.rx.event.bind { [weak self] (_) in
            self?.close()
        }.disposed(by: rx.disposeBag)


        self.view.layoutIfNeeded()
        addPopGesture()
    }
    
    ///设置约束为显示状态
    private func updateLayoutToShow() {
        if let constraint = contentViewBottomConstraint {
            constraint.constant = 0
        }

        //更新高度约束
        if let constraint = contentHeightConstraint {
            let style = self.popUpContentSheetStyle
            switch style {
            case .topOffset(let offset):
                constraint.constant = UIScreen.main.bounds.height - offset

            case .content(let height):
                constraint.constant = height

            case .defaultTopOffset:
                constraint.constant = UIScreen.main.bounds.height - kTopInset
            case .auto:
                break
            }

        }

        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let `self` = self else { return }
            self.backView.alpha = 0.3
            self.view.layoutIfNeeded()
            self.backView.frame = self.view.bounds
        }
    }
    
    
    
    //关闭
    func close(completion: VoidBlock? = nil) {
        if let constraint = self.contentViewBottomConstraint {
            constraint.constant = 0 - self.view.frame.size.height
        }
        else if let constraint = self.contentHeightConstraint {
            constraint.constant = 0
        }

        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.backView.alpha = 0
            self?.view.layoutIfNeeded()
        }) { [weak self] (finished) in
            self?.view.removeFromSuperview()
            self?.removeFromParent()
            completion?()
            self?.closedHandle?()
        }
        
    }


    //背景点击View
    private var backView: UIView {
        let tag = 3732842
        if let temp = self.view.viewWithTag(tag) {
            return temp
        }
        let tapView = UIView()
        tapView.tag = tag
        tapView.alpha = 0
        tapView.backgroundColor = UIColor.black//.withAlphaComponent(0)
        return tapView
    }

    //添加下拉手势
    private func addPopGesture() {
        
        let pan = UIPanGestureRecognizer()
        self.view.addGestureRecognizer(pan)
        pan.rx.event.bind { [weak self] gesture in
            self?.popGestureMove(gesture)
        }.disposed(by: rx.disposeBag)
    }
    
    private func popGestureMove(_ pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: self.view)
        
        var constant: CGFloat = 0

        if let constraint = contentViewBottomConstraint {
            constant = constraint.constant - point.y
            constant = constant > 0 ? 0 : constant
            constraint.constant = constant
        }
        else {
            return
        }
        
        
        
        pan.setTranslation(CGPoint.zero, in: self.view)
        
        
        if pan.state == .began {
            
        }
        else if pan.state == .changed {
            
        }
            
        else if pan.state == .ended {
            if contentViewBottomConstraint != nil {
                let contentHeight = self.view.frame.size.height
                if constant < (0 - contentHeight) / 5.0 {
                    self.close()
                }
                else {
                    updateLayoutToShow()
                }
            }
        }
    }
}
