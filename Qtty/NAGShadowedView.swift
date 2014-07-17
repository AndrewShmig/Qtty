//
//  NAGShadowedView.swift
//  Qtty
//
//  Created by AndrewShmig on 04/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit
import Foundation

class NAGShadowedView: UIView {
  
  init(frame: CGRect) {
    super.init(frame: frame)
    
    // создаем тень
    let shadow = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
    shadow.layer.shadowOpacity = 0.65
    shadow.layer.shadowRadius = 4
    shadow.layer.shadowColor = UIColor.blackColor().CGColor
    shadow.layer.shadowOffset = CGSize(width: 0, height: 0)
    
    // создаем форму для тени
    let diameter = (CGRectGetWidth(frame) / CGRectGetHeight(frame)) * CGRectGetWidth(frame)
    let radius = diameter / 2
    let xCenter = CGRectGetWidth(frame) / 2
    let yCenter = CGRectGetHeight(frame) + radius
    let angle = 2 * asin(CGRectGetWidth(frame) / (2 * radius))
    let endAngle = M_PI + (M_PI - Double(angle)) / 2.0
    let startAngle = endAngle + Double(angle)
    
    let shadowPath = CGPathCreateMutable()
    CGPathMoveToPoint(shadowPath, nil, 0, CGRectGetHeight(frame) / 2)
    CGPathAddLineToPoint(shadowPath, nil, frame.size.width, CGPathGetCurrentPoint(shadowPath).y)
    CGPathAddLineToPoint(shadowPath, nil, CGPathGetCurrentPoint(shadowPath).x, frame.size.height)
    CGPathAddArc(shadowPath, nil, xCenter, yCenter, radius, CGFloat(startAngle), CGFloat(endAngle), true)
    CGPathAddLineToPoint(shadowPath, nil, 0, frame.size.height)
    CGPathCloseSubpath(shadowPath)
    
    shadow.layer.shadowPath = shadowPath
    
    self.addSubview(shadow)
  }
  
}
