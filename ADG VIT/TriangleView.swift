//
//  TriangleView.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    @IBInspectable var color: UIColor = projectDetailsBackgroundColor
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let height = rect.height
        let width = rect.width
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0.0, y: height))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width, y: 0.0))
        bezierPath.close()
        
        self.color.set()
        bezierPath.lineWidth = 2.0
        
        bezierPath.stroke()
        bezierPath.fill()
        
    }
    

}
