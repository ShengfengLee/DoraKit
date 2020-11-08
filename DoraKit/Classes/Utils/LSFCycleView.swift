//
//  LSFCycleView.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/2.
//  Copyright © 2017年 李胜锋. All rights reserved.
//

import UIKit

/*  使用实例
 func test() {
 var banners = [Any]() //数据源
 var bannerView = LSFCycleView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 110))
 bannerView.isShowPageControl = true //是否显示pageControl
 bannerView.direction = .horizontal  //设置滚动方向
 
 //设置item数量
 bannerView.numberOfCellBlock = {
 return banners.count
 }
 
 //返回item
 bannerView.cellBlock = {
 let imageView = UIImageView.init()
 return imageView
 }
 
 //更新item的UI、数据源
 bannerView.updateCellBlock = { (index, cell) in
 let imageView = cell as! UIImageView
 let imageUrl = banners[index]
 imageView.sd_setImage(with: URL.init(string: imageUrl)!)
 }
 
 //item点击事件
 bannerView.selectBlock = { (index) in
 let ad = banners[index]
 }
 
 //刷新数据
 bannerView.reloadData()
 }
 // */


///滚动方向
public enum ScrollDirection  {
    ///水平
    case horizontal
    ///垂直
    case vertical
}


/// 轮播图
public class LSFCycleView: UIView {
    
    
    //滚动方向
    public var direction:ScrollDirection = .vertical
    
    //数据相关block
    public var selectBlock: ((_ index:Int)->Void )?
    public var updateCellBlock:((_ index:Int, _ cell:UIView) -> Void)?
    public var cellBlock:(() -> UIView)?
    //没有数据时的占位图
    public var placeholdCellBlock:(() -> UIView?)?
    public var numberOfCellBlock:(() -> Int)?
    
    
    ///是否允许用户滑动
    var isScrollEnabled : Bool = true
    
    var autoRun: Bool = false
    //    自动滚动定时器
    private var autoScrollTimer:Timer?
    var scrollView: UIScrollView?
    var forwordView, currentView, nextView : UIView?
    var placeholdView: UIView?
    var pageControl: LSFPageControl?
    var pageControlFrame: CGRect? {
        didSet {
            pageControl?.frame = self.pageControlFrame ?? CGRect(x: 5, y: 0, width: self.lsf_width - 10, height: 10)
        }
    }
    var timeInterval: TimeInterval = 3
    var duration: TimeInterval = 0.6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    
    ///show pageControl
    var isShowPageControl:Bool = false{
        didSet {
            pageControl?.removeFromSuperview()
            pageControl = nil
            
            if isShowPageControl {
                configPageControl()
            }
        }
    }
    
    private(set) var dataCount:Int = 0
    private var forwordIndex:Int = -1
    private var nextIndex:Int = 1
    var currentIndex:Int = 0{
        didSet {
            
            if dataCount > 0 {
                if currentIndex <= -1 {
                    currentIndex = dataCount - 1
                }
                else if currentIndex >= dataCount {
                    currentIndex = 0
                }
                
                forwordIndex = currentIndex - 1
                if currentIndex == 0 {
                    forwordIndex = dataCount - 1
                }
                
                nextIndex = currentIndex + 1
                if currentIndex == dataCount - 1 {
                    nextIndex = 0
                }
                
                if let current = currentView, let forword = forwordView, let next = nextView {
                    updateCellBlock?(currentIndex, current)
                    updateCellBlock?(forwordIndex, forword)
                    updateCellBlock?(nextIndex, next)
                }
                
                
                pageControl?.currentPage = currentIndex
                indexHandle?(currentIndex)
            }
            
        }
    }
    var indexHandle: IntBlock?
    
    
    
    // MARK:-  UI 初始化
    func setup() {
        configScrollView()
    }
    
    //    初始化scrollView
    private func configScrollView() {
        scrollView = UIScrollView.init()
        scrollView?.delegate = self
        scrollView?.isPagingEnabled = true
        scrollView?.bounces = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        self.addSubview(scrollView!)
        
        if #available(iOS 11, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        }
        
        //显示默认占位图
        self.showPlaceholdView(true)
    }
    
    
    private func clear() {
        stop()
        forwordView?.removeFromSuperview()
        forwordView = nil
        
        currentView?.removeFromSuperview()
        currentView = nil
        
        nextView?.removeFromSuperview()
        nextView = nil
    }
    
    
    private func configCellViews() {
        
        assert(cellBlock != nil, "cellBlock 不能为空")
        
        forwordView = cellBlock!()
        currentView = cellBlock!()
        nextView = cellBlock!()
        
        
        forwordView?.clipsToBounds = true
        currentView?.clipsToBounds = true
        nextView?.clipsToBounds = true
        
        currentView?.isUserInteractionEnabled = true
        let currentTap = UITapGestureRecognizer.init(target: self, action: #selector(LSFCycleView.currentTap))
        currentView?.addGestureRecognizer(currentTap)
        
        forwordView?.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(LSFCycleView.currentTap))
        forwordView?.addGestureRecognizer(tap2)
        
        nextView?.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(LSFCycleView.currentTap))
        nextView?.addGestureRecognizer(tap3)
        
        
        
        scrollView?.addSubview(forwordView!)
        scrollView?.addSubview(currentView!)
        scrollView?.addSubview(nextView!)
    }
    
    
    private func configPageControl() {
        pageControl = LSFPageControl()
        
        pageControl?.currentPageIndicatorTintColor = UIColor.white;
        pageControl?.tintColor = UIColor.init(white: 1, alpha: 0.5)
        
        self.addSubview(pageControl!)
        
        pageControl?.frame = self.pageControlFrame ?? CGRect(x: 10, y: 0, width: self.lsf_width - 20, height: 10)
    }
    
    @objc func currentTap() {
        selectBlock?(currentIndex)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public func reloadData(_ autoRun: Bool = true) {
        clear()
        scrollView?.isScrollEnabled = false
        
//        assert(numberOfCellBlock != nil, "numberOfCellBlock 不能为空")
        dataCount = numberOfCellBlock?() ?? 0
        
        if dataCount == 0 {
            showPlaceholdView(true)
            return
        }
        //隐藏默认占位图
        showPlaceholdView(false)
        
        configCellViews()
        layoutSubviews()
        layoutIfNeeded()
        
        
        self.pageControl?.numberOfPages = dataCount
        self.pageControl?.isHidden = (dataCount == 1)

        scrollTo(1)
        self.currentIndex = 0
        
        if dataCount > 1 {
            scrollView?.isScrollEnabled = isScrollEnabled
        }
        
        self.autoRun = autoRun
        if autoRun {
            //开启轮播定时器
            run()
        }
    }
    
    //显示默认占位图
    func showPlaceholdView(_ isShow: Bool) {
        self.placeholdView?.removeFromSuperview()
        
        if isShow, let placeholdV = placeholdCellBlock?() {
            placeholdV.frame = self.bounds
            self.addSubview(placeholdV)
            self.placeholdView = placeholdV
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        
        switch direction {
        //垂直方向
        case .vertical:
            scrollView?.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            scrollView?.contentSize = CGSize.init(width: size.width, height: size.height * 3)
            
            forwordView?.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            currentView?.frame = CGRect.init(x: 0, y: size.height, width: size.width, height: size.height)
            nextView?.frame = CGRect.init(x: 0, y: size.height * 2, width: size.width, height: size.height)
            
        //水平方向
        default:
            scrollView?.frame       = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            scrollView?.contentSize = CGSize.init(width: size.width * 3, height: size.height)
            
            forwordView?.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            currentView?.frame = CGRect.init(x: size.width, y: 0, width: size.width, height: size.height)
            nextView?.frame    = CGRect.init(x: size.width * 2, y: 0, width: size.width, height: size.height)
        }
        
        self.placeholdView?.frame = self.bounds
//        pageControl?.center = CGPoint(x: self.lsf_width / 2.0, y: self.lsf_height - 5)
    }
    
    
    
    
    // MARK: - 定时器事件
    func run() {
        stop()
        if dataCount > 1, self.autoRun {
            autoScrollTimer = Timer(timeInterval: self.timeInterval, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(autoScrollTimer!, forMode: .common)
        }
    }
    
    func stop() {
        if autoScrollTimer != nil {
            autoScrollTimer?.invalidate()
            autoScrollTimer = nil
        }
    }
    
    @objc func onTimer() {
        
        UIView.animate(withDuration: self.duration, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.scrollTo(2)
            }
        }) { [weak self] (finished) in
            if let strongSelf = self {
                strongSelf.scrollTo(1)
            }
            self?.currentIndex += 1
        }
        
    }
    
    private func scrollTo(_ index: Int) {
        //垂直
        if self.direction == .vertical {
            self.scrollView?.setContentOffset(CGPoint.init(x: 0, y: self.frame.size.height * CGFloat(index)), animated: false)
        }
        else {
            self.scrollView?.setContentOffset(CGPoint.init(x: self.frame.size.width * CGFloat(index), y: 0), animated: false)
        }
    }
}

//MARK:- scrollView代理事件
extension LSFCycleView :UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var tempIndex = 0
        
        switch direction {
        //垂直
        case .vertical:
            tempIndex = Int(scrollView.contentOffset.y / self.frame.size.height)
            scrollView.setContentOffset(CGPoint.init(x: 0, y: self.frame.size.height), animated: false)
            
        //水平
        default:
            tempIndex = Int(scrollView.contentOffset.x / self.frame.size.width)
            scrollView.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0), animated: false)
        }
        
        if tempIndex == 2 {
            self.currentIndex += 1
        }
        else if  tempIndex == 0 {
            self.currentIndex -= 1
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果拖动结束时，此时正好也滑动结束，减速结束和滑动结束并不等价。 所以需要手动调用下
        if decelerate == false {
            scrollViewDidEndDecelerating(scrollView)
        }
        else {
            self.run()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stop()
    }
}


class LSFPageControl: UIPageControl {
    
    @IBInspectable var alignment: NSTextAlignment = .left
    @IBInspectable var space: CGFloat = 3
    @IBInspectable var pageWith: CGFloat = 6
    @IBInspectable var pageHeight: CGFloat = 6
    
    @IBInspectable var currentPageWith: CGFloat = 6
    @IBInspectable var currentPageHeight: CGFloat = 6
    
    @IBInspectable var itemCornerRadius: CGFloat = 3
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
        for (index, subView) in self.subviews.enumerated() {
            subView.layer.masksToBounds = true
            subView.layer.cornerRadius = itemCornerRadius
            
            if index == self.currentPage {
                let y = (self.lsf_height - currentPageHeight) / 2
                subView.frame = CGRect.init(x: 0, y: y, width: currentPageWith, height: currentPageHeight)
            }
            else {
                let y = (self.lsf_height - pageHeight) / 2
                subView.frame = CGRect.init(x: 0, y: y, width: pageWith, height: pageHeight)
            }
            
            //右对齐
            if alignment == .right {
                var right = self.lsf_width - CGFloat(self.numberOfPages - 1 - index) * (pageWith + space)
                if index < self.currentPage {
                    right = right + pageWith - currentPageWith
                }
                subView.lsf_right = right
            }
            else if alignment == .center {
                let x = (CGFloat(index) - CGFloat(numberOfPages - 1) / 2)
                let offset = x * (pageWith + space)
                var centerX = self.lsf_width / 2 + offset
                if index > self.currentPage {
                    centerX = centerX + (currentPageWith - pageWith) / 2
                }
                else if index < self.currentPage {
                    centerX = centerX - (currentPageWith - pageWith) / 2
                }
                subView.lsf_centerX = centerX
            }
            else{
                var x = (pageWith + space) * CGFloat(index)
                if index > self.currentPage {
                    x = x - pageWith + currentPageWith
                }
                
                subView.lsf_x = x
            }
            
        }
        
//        self.sizeToFit()
//
//
//        //计算整个pageControll的宽度
//        let newW = self.frame.size.width
//
//        //设置新frame
//        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newW, height: self.frame.size.height)
        
        
        
        //self.layoutIfNeeded()
    }
}
