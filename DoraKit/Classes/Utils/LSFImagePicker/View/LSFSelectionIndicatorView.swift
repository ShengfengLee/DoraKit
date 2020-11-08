//
//  LSFSelectionIndicatorView.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/10.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit
import SnapKit

class LSFSelectionIndicatorView: UIView {
    
    
    let radiusView = UIView()
    let tagLabel = UILabel()

    var selectHandle: VoidBlock?
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        //self.backgroundColor = UIColor.white
        
        radiusView.backgroundColor = UIColor.lsf_color16(0xCCCCCC)
        addSubview(radiusView)
        radiusView.snp.makeConstraints { (maker) in
            maker.top.trailing.equalToSuperview()
            maker.width.height.equalTo(size)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(taped))
        radiusView.isUserInteractionEnabled = true
        radiusView.addGestureRecognizer(tap)
        radiusView.layer.cornerRadius = size / 2.0
        
        
        tagLabel.textAlignment = .center
        tagLabel.textColor = .white
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (maker) in
            maker.size.equalTo(radiusView.snp.size)
            maker.center.equalTo(radiusView.snp.center)
        }
        
        
        set(number: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
 
    
    @objc
    func taped() {
        selectHandle?()
    }
    
    func set(number: Int?) {
        tagLabel.isHidden = (number == nil)
        if let number = number {
            radiusView.backgroundColor = UIColor.lsf_color16(0x6B3DF5)
            radiusView.layer.borderColor = UIColor.clear.cgColor
            radiusView.layer.borderWidth = 0
            tagLabel.text = "\(number)"
        } else {
            radiusView.backgroundColor = UIColor.lsf_color16(0xACACAC).withAlphaComponent(0.6) //UIColor.white.withAlphaComponent(0.3)
            radiusView.layer.borderColor = UIColor.lsf_color16(0xF0F0F0).cgColor // UIColor.white.cgColor
            radiusView.layer.borderWidth = 1
            tagLabel.text = ""
        }
    }
}
