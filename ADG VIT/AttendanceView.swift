//
//  AttendanceView.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 11/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class AttendanceView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var percentage: CGFloat = 0.9 {
        didSet {
            self.prepareForEditing()
        }
    }
    
    let shapeLayer = CAShapeLayer()
    var path = UIBezierPath()
    
    override func didMoveToSuperview() {
        
        let backLayer = CAShapeLayer()
        backLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.strokeColor = UIColor.white.cgColor
        backLayer.lineWidth = 4.0
        self.layer.addSublayer(backLayer)
        
//        self.shapeLayer.path = path.cgPath
        self.shapeLayer.lineWidth = 4.0
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.strokeColor = borderColor.cgColor
        self.shapeLayer.strokeStart = 0.0
        self.shapeLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(self.shapeLayer)
        
    }
    
    func prepareForEditing() {
        
        self.path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: self.frame.width / 2.0, startAngle: 0, endAngle: CGFloat(M_PI) * 2.0 * self.percentage, clockwise: true)
        
        self.shapeLayer.path = self.path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // The next two line preserves the final shape of animation,
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false

        
        self.shapeLayer.add(animation, forKey: nil)
        
    }
 

}
