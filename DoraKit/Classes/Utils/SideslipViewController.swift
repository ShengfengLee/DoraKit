//
//  SideslipViewController.swift
//  Pods-SwiftDora_Example
//
//  Created by 李胜锋 on 2018/1/29.
//

import UIKit

public func sideslipOpenLeftMenu(completion:(()->Void)? = nil) {
    SideslipViewController.shareSideslip?.openLeftMenu(completion: completion)
}

public func sideslipCloseLeftMenu(completion:(()->Void)? = nil) {
    SideslipViewController.shareSideslip?.closeLeftMenu(completion: completion)
}


public enum SideslipNotificationName: String {
    case willOpen = "SideslipNotification.willOpen"
    case didOpen = "SideslipNotification.didOpen"
    case willClose = "SideslipNotification.willClose"
    case didClose = "SideslipNotification.didClose"
}

public class SideslipViewController: UIViewController {
    
    
    public var leftVC: UIViewController!
    public var mainVC: UIViewController!
    public var maxWidth: CGFloat = 300
    public var openOffset: CGFloat = 100
    public var sideslipCompletion:( (_ isOpen:Bool)->Void )?
    
    //显示侧栏时，加载在Mian VC上的点击视图
    public var mainTapView:UIView?
    
    public static let shareSideslip = UIApplication.shared.keyWindow?.rootViewController as? SideslipViewController
    
    public init(_ controller:UIViewController, leftMenuVC:UIViewController, leftWidth:CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.mainVC = controller
        self.leftVC = leftMenuVC
        self.maxWidth = leftWidth
        
        view.addSubview(leftMenuVC.view)
        view.addSubview(controller.view)
        
        addChild(controller)
        addChild(leftMenuVC)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        leftVC.view.transform = CGAffineTransform.init(translationX: -maxWidth, y: 0)
    
        for childVC in mainVC.children {
            addScreenEdgePanGestureRecognizerToView(view: childVC.view)
        }
    }
    
    //给子视图添加左边侧滑手势
    private func addScreenEdgePanGestureRecognizerToView(view:UIView)  {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(SideslipViewController.edgePanGesture(_:)))
        pan.edges = .left
        view.addGestureRecognizer(pan)
    }
    
    @objc
    private func edgePanGesture(_ pan:UIScreenEdgePanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if pan.state == .began {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideslipNotificationName.willOpen.rawValue), object: nil)
        }
        else if pan.state == .changed, offsetX <= maxWidth {
            mainVC.view.transform = CGAffineTransform.init(translationX: max(offsetX, 0), y: 0)
            leftVC.view.transform = CGAffineTransform.init(translationX: -maxWidth + offsetX, y: 0)
        }
        else if pan.state == .ended ||
            pan.state == .cancelled ||
            pan.state == .failed {
            
            if offsetX > openOffset {
                openLeftMenu(postNotification: false)
            }
            else  {
                closeLeftMenu()
            }
        }
    }
    
    //打开左侧菜单
    public func openLeftMenu(completion:(()->Void)? = nil, postNotification: Bool = true) {

        if  postNotification {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideslipNotificationName.willOpen.rawValue), object: nil)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.leftVC.view.transform = CGAffineTransform.identity
            self.mainVC.view.transform = CGAffineTransform.init(translationX: self.maxWidth, y: 0)
        }) { (finish) in
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideslipNotificationName.didOpen.rawValue), object: nil)
            
            self.addMainVcView()
            self.sideslipCompletion?(true)
            completion?()
        }
    }
    
    //关闭左侧菜单
    public func closeLeftMenu(completion:(()->Void)? = nil) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideslipNotificationName.willClose.rawValue), object: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.leftVC.view.transform = CGAffineTransform.init(translationX: -self.maxWidth, y: 0)
            self.mainVC.view.transform = CGAffineTransform.identity
        }) { (finish) in
            
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideslipNotificationName.didClose.rawValue), object: nil)
            
            self.removeMainVcView()
            self.sideslipCompletion?(false)
            completion?()
        }
    }
    
    func addMainVcView() {
        if mainTapView == nil {
            mainTapView = UIView.init(frame: mainVC.view.bounds)
            mainVC.view.addSubview(mainTapView!)
            mainTapView?.backgroundColor = UIColor.black
            mainTapView?.alpha = 0
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(SideslipViewController.backTap))
            mainTapView?.addGestureRecognizer(tap)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.mainTapView?.alpha = 0.3
            })
        }
        
    }
    
    func removeMainVcView() {
        mainTapView?.removeFromSuperview()
        mainTapView = nil
    }
    
    @objc func backTap() {
        closeLeftMenu()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK:-  状态栏， 屏幕旋转
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return mainVC.preferredStatusBarStyle
        }
    }
    
    public override var shouldAutorotate: Bool {
        get {
            return mainVC.shouldAutorotate
        }
    }
    // 隐藏状态栏
    public override var prefersStatusBarHidden : Bool {
        return mainVC.prefersStatusBarHidden
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return mainVC.supportedInterfaceOrientations
        }
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return mainVC.preferredInterfaceOrientationForPresentation
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
