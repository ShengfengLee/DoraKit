//
//  SignView.swift
//  Sign
//
//  Created by 安诚 on 2017/12/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

public class DoraSignView: UIView {

    var context: CGContext!
    var image: UIImage!
    var un_image: UIImage!
    var imageWidth: CGFloat = 20
    var padding: CGFloat = 20
    var lineWidth: CGFloat = 1.0
    var lineColor = UIColor.red
    var un_lineColor = UIColor.cyan
    var selectCount: Int = 0
    var row: Int = 5
    var column: Int = 5
    
    private  var space: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }
    
    
    /// 初始化SignView
    ///
    /// - Parameters:
    ///   - image: 选中的图片
    ///   - un_imamge: 未选中的图片
    ///   - imageWidth: 图片宽度
    ///   - lineWidth: 线宽
    ///   - lineColor: 选中的线颜色
    ///   - un_lineColor: 未选中的线颜色
    ///   - selectCount: 选中的个数
    ///   - padding: 图形内边距
    ///   - space: 点间距
    ///   - row: 行数
    ///   - column: 列数
    init(frame: CGRect,
         image:UIImage,
         un_imamge: UIImage,
         imageWidth: CGFloat = 20.0,
         lineWidth: CGFloat = 1.0,
         lineColor: UIColor = UIColor.red,
         un_lineColor: UIColor = UIColor.cyan,
         selectCount: Int = 0,
         padding: CGFloat = 20.0,
         row: Int = 5,
         column: Int = 5) {
        
        self.image = image
        self.un_image = un_imamge
        self.imageWidth = imageWidth
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.un_lineColor = un_lineColor
        self.selectCount = selectCount
        self.padding = padding
        self.row = row
        self.column = column
        
        super.init(frame: frame)
        update()
    }
    
   
    func update() {
        space = (self.frame.size.width - padding * 2) / CGFloat(column - 1)
        setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        ///画线
        context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor(self.lineColor.cgColor)
        
        var index = -1
        for i in 0...(row - 1){
            var range = stride(from: 0, through: column - 1, by: 1)
            if i % 2 != 0 {
                range = stride(from: column - 1, through: 0, by: -1)
            }
            for j in range{
                index += 1
                let x = padding + CGFloat(j) * space
                let y = padding + CGFloat(i) * space
                if i == 0, j == 0{
                    context?.move(to: CGPoint.init(x: x, y: y))
                }else{
                    context?.addLine(to: CGPoint.init(x: x, y: y))
                }
                
                if index  == selectCount - 1 {
                    context?.strokePath()
                    context?.setStrokeColor(un_lineColor.cgColor)
                    context?.move(to: CGPoint.init(x: x, y: y))
                }
            }
            
            
        }
        context?.strokePath()
        
        ///图片
            index = -1
        for i in 0...(row - 1){
            var range = stride(from: 0, through: column - 1, by: 1)
            if i % 2 != 0{
                range = stride(from: column - 1, through: 0, by: -1)
            }
            for j in range{
                index += 1
                let x =  padding + CGFloat(j) * space
                let y =  padding + CGFloat(i) * space
                ///判断
                var img = un_image
                
                if index < selectCount{
                    img = image
                }
                if img == nil{
                    img = UIImage.init(named: "已签到_icon")
                }
                context?.saveGState()
                context?.translateBy(x: x, y: y)
                context?.scaleBy(x: 1, y: -1)
                context?.draw(img!.cgImage!, in: CGRect.init(x: 0 - imageWidth / 2.0, y: 0 - imageWidth / 2.0, width: imageWidth, height: imageWidth))
                context?.restoreGState()
                
            }
            
        }
    }

    

}
