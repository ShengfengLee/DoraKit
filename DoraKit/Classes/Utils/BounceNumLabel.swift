//
//  BounceNumLabel.swift
//  bounceLabel
//
//  Created by 安诚 on 2017/11/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit



class BounceNumLabel : UILabel{

    public var time:TimeInterval = 0.5
    public var ratio : Float = 30
    public var number: Float = 0 {
        didSet{
            setup()
        }
    }
    
    private var timer: Timer?
    private var timeInterval: TimeInterval = 0.2
    private func setup(){
        
        if  timer != nil, (timer?.isValid)! {
            timer?.invalidate()
            timer = nil
        }
        
        let lastValue = Float(self.text ?? "0")
        let delta = number - lastValue!
        
        if delta == 0 {
            return
        }
        
        if delta > 0 {
            timeInterval = time / Double(ratio)
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(setupLabel), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
          
        }
    }
    
    var flag:Float = 1
    @objc func setupLabel(){
        if let timeUse = timer {

            let lastValue = Float(self.text ?? "0") ?? 0

            let randomDelta = ((Float(arc4random_uniform(2) + 1) ) * ratio)
            print("********\(randomDelta)")
            let resValue = Float(lastValue + randomDelta)
            
            
            if (resValue >= number) || (flag == ratio) {
                self.text = String.init(format: "%.2f", number)
                flag = 1
                timeUse.invalidate()
                timer = nil
                return
            }else{
                self.text = String.init(format: "%.2f", resValue)
            }
            flag = flag + 1
            
            print(flag)
        }
        
    }
    
}
