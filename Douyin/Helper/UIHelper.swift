//
//  UIHelper.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/21.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit
var layers:[CAShapeLayer] = []
extension UIView {
 @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius=newValue
        }
    }
    
  @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth=newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor=newValue.cgColor
        }
    }
    
    func raiseAnimation(imageName:String,delay:TimeInterval){
        let path=UIBezierPath()
        //起点-视图中间
        let startPoint=CGPoint(x: bounds.midX, y: bounds.midY)
        
        //控制点的位移
        let randomOffsetControl:[CGFloat]=[2,1.5,3]
        let controlPointX=randomOffsetControl.randomElement()! * bounds.maxX
        let controlPointY=randomOffsetControl.randomElement()! * bounds.maxY
        
        //终点的位移
        let randomOffsetEnd:[CGFloat]=[1.5,1,0.8,2.5,3,2]
        let endPointX=randomOffsetEnd.randomElement()! * bounds.maxX
        let endPointY=randomOffsetEnd.randomElement()! * bounds.maxY
        
        //终点
        let endPoint=CGPoint(x: startPoint.x-endPointX, y: startPoint.y-endPointY)
        //控制点
        let controlPoint=CGPoint(x:startPoint.x-controlPointX,y:startPoint.y-controlPointY)
        
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        let group=CAAnimationGroup()
        group.duration=4
        group.beginTime=CACurrentMediaTime()+delay
        group.repeatCount = .infinity
        group.isRemovedOnCompletion=false
        group.fillMode = .forwards
        group.timingFunction=CAMediaTimingFunction(name: .linear)
        let pathAnimation=CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path=path.cgPath
        
        let rotateAnimation=CAKeyframeAnimation(keyPath: "transform.rotation")
        rotateAnimation.values=[0, .pi/2.0, .pi/1.0]
        
        let alphaAnimation=CAKeyframeAnimation(keyPath: "opacity")
        alphaAnimation.values=[0,0.3,1,0.3,0]
        
        let scaleAnimation=CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values=[1.0,0.8,2]
        
        group.animations=[pathAnimation,rotateAnimation,alphaAnimation,scaleAnimation]
        
        let layer=CAShapeLayer()
        layer.opacity=0
        layer.contents=UIImage(named: imageName)?.cgImage
        layer.frame=CGRect(origin: startPoint, size: CGSize(width: 20, height: 20))
        self.layer.addSublayer(layer)
        layer.add(group, forKey: nil)
        layers.append(layer)
    }
    
    func resetViewAnimation() {
        for layer in layers{
            layer.removeFromSuperlayer()
        }
        self.layer.removeAllAnimations()
    }
}
